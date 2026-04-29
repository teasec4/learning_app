# Hearthstone-like Game Engine

## Concept

Turn-based battle: player vs AI. Cards in the deck are the user's Chinese vocabulary.
Correct answer = damage to the enemy (1-3 HP depending on speed).
Wrong answer or timeout = 1 damage to you.

## Files

| File | Location |
|------|----------|
| GameMode enum | `lib/domain/entities/game_mode.dart` |
| GameState class | `lib/domain/entities/game_state.dart` |
| GameResult class | `lib/presentation/view_models/game_view_model.dart` (inline) |
| GameViewModel | `lib/presentation/view_models/game_view_model.dart` |
| GameBattlePage | `lib/presentation/pages/game/game_battle_page.dart` |
| GameLobbyPage | `lib/presentation/pages/game/game_lobby_page.dart` |

## Game Loop

```
1. SHUFFLE & DEAL
   Shuffle all cards in the deck.
   Deal 4 cards (or all if deck < 4) to player's hand.

2. PICK QUESTION
   AI picks 1 random card from the player's hand.
   Shows its translation (in translation→word mode).

3. PLAYER TURN (10s timer)
   Player picks a card from their hand that matches the translation.
   Correct → card is discarded, AI takes damage (1-3 HP, speed-based)
   Wrong → player takes 1 damage, card stays in hand
   Timeout → player takes 1 damage, card stays in hand

4. NEXT TURN
   Player draws 1 card from the remaining pile (if any).
   New question card is picked from the new hand.
   Timer resets to 10s.

5. GAME OVER when:
   - AI HP ≤ 0 → Player wins
   - Player HP ≤ 0 → Player loses
   - No cards left (hand + deck empty) → Player wins
   - Deck has no cards at start → Game over immediately with error message
```

## Battle Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| handSize | 4 | Cards in hand at start (or deck size if smaller) |
| timePerCard | 10s | Time to answer |
| hp | 10 | Player HP |
| aiHp | 10 | AI HP |
| damageWrong | 1 | Damage to player for wrong answer |
| damageTimeout | 1 | Damage to player for timeout |
| damageCorrect | 1-3 | Linear: 3 (instant) → 1 (10s) |

### Damage Formula

```dart
// Linear damage: faster answer = more damage
// 0s → 3, 5s → 2, 10s → 1
int _calculateDamage(int elapsedSeconds) {
  final clamped = elapsedSeconds.clamp(0, 10);
  final damage = 3 - 2 * (clamped / 10);
  return damage.round().clamp(1, 3);
}
```

- 0s → 3 HP damage
- 5s → 2 HP damage  
- 10s → 1 HP damage

## Game Modes

All modes use the same engine. Only the question generator changes.
**MVP:** only `translationToWord` implemented.

| Mode | Shows | Player picks |
|------|-------|--------------|
| translation→word | Translation (English) | Chinese char(s) from hand |
| word→translation | Chinese char(s) | Translation from hand (future) |
| cloze | Sentence with blank | Missing word from hand (future) |

### GameMode enum

```dart
enum GameMode {
  translationToWord;

  String get displayName => 'Translation → Character';
  String get description => 'See the translation, pick the matching Chinese character.';
}
```

GameMode is selected on GameLobbyPage and passed to GameBattlePage via GoRouter's `state.extra`.

## GameState

```dart
enum GamePhase { waitingForAnswer, showingResult, gameOver }

class GameState {
  List<WordCard> playerHand;
  List<WordCard> remainingCards;       // cards not yet drawn
  WordCard? currentQuestion;           // the card AI is asking about
  Deck deck;
  GameMode mode;
  int playerHp;
  int aiHp;
  int score;                           // accumulated damage dealt
  int turnNumber;
  int correctCount;
  int totalCards;                      // total cards in deck at start
  GamePhase phase;
  DateTime? turnStartTime;
  int timerSecondsRemaining;
  bool? lastAnswerCorrect;
  String? resultMessage;
}
```

State is immutable — all mutations go through `copyWith()`.

## GameResult (internal)

Created inline in GameViewModel. Used by GameBattlePage to display stats:

```dart
class GameResult {
  final bool playerWon;
  final int score;
  final int correctCount;
  final int totalCards;
  final int turnsPlayed;
}
```

## GameViewModel

```dart
class GameViewModel extends ChangeNotifier {
  // Accesses AppServices singleton directly for repositories
  final WordCardRepository _wordCardRepository;
  final GameSessionRepository _gameSessionRepository;

  Future<void> startGame(Deck deck, GameMode mode);  // load cards, shuffle, deal
  void selectCard(WordCard card);                     // player picks a card
  void restart();                                     // restart with same deck
  void dispose();                                     // cancel timer, mark disposed
}
```

All game logic lives inside the ViewModel. Presentation layer only renders state.
GameViewModel is created via `ChangeNotifierProvider` scoped to `GameBattlePage`:

```dart
return ChangeNotifierProvider(
  create: (_) => GameViewModel()..startGame(deck, widget.mode),
  child: _BattleScreen(deck: deck),
);
```

### Key methods

| Method | Purpose |
|--------|---------|
| `startGame()` | Load cards from DB, shuffle, deal 4, create GameSession in Isar, pick question, start timer |
| `selectCard()` | Evaluate answer, calculate damage, advance turn or end game |
| `_advanceTurn()` | Draw 1 from pile, pick new question, restart timer |
| `_onTimeout()` | Handle 10s timeout — player takes 1 damage |
| `_endGame()` | Cancel timer, save GameSession to Isar as completed |
| `restart()` | Reset and call startGame with same deck/mode |

### Timer

- Uses `Timer.periodic(const Duration(seconds: 1))` to count down from 10
- Timer ticks update `timerSecondsRemaining` in state
- At 0: calls `_onTimeout()`
- Cancelled on: player input (`selectCard`), timeout, game over, dispose

## Saving Results

When a game ends, `GameViewModel._endGame()` saves the result as a `GameSession` in Isar:
- status → `completed`
- score (accumulated damage dealt), correctCount, totalCards
- completedAt timestamp

A `GameSession` is also created on `startGame()` (status: `inProgress`) and updated on game end.

## Starting a Battle (data flow)

```
GameLobbyPage
  → user selects deck + mode
  → context.push(AppRoutes.gameBattle(deck.id), extra: {'mode': selectedMode})
  → GoRouter builds GameBattlePage(deckId: deckId, mode: mode)
  → GameBattlePage.build() creates ChangeNotifierProvider<GameViewModel>
  → GameViewModel.startGame(deck, mode) loads cards from DB
```

## AI Opponent

**MVP implementation:**
- No independent AI turn (player-only turns)
- AI "asks" by picking a **random card from the player's hand** as the target question
- AI "attacks" if player times out (1 damage to player)
- AI "attacks" if player picks wrong card (1 damage to player)
- No strategy or adaptation
- AI always starts with 10 HP and never regenerates
