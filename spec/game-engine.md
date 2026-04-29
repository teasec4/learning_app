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

## Game Loop (Step-by-Step Phases)

The game is divided into 3 repeating phases per turn:

```
TURN START
  │
  ├── 1. AI TURN (~1.5s)
  │      AI "plays" a card — reveals the question (English translation)
  │      Picks 1 random card from player's hand as the target
  │      Question card appears in center with "AI's turn..." spinner
  │      After 1.5s → transition to Player Turn
  │
  ├── 2. PLAYER TURN (10s timer)
  │      Player sees the English translation + their hand of Chinese chars
  │      "Your turn! Pick the matching card." label
  │      Timer bar counts down from 10s
  │      Player taps a card → transition to Result Shown
  │      Timeout → Result Shown (wrong answer)
  │
  └── 3. RESULT SHOWN (~1.2-1.5s)
         Correct → card glows green, "+3 HP! 汉字" message
                    Card removed from hand, AI takes damage
         Wrong → card glows red, "Wrong! It was 汉字" message
                  Player takes 1 damage
         After delay → advance to next turn or game over
```

### Complete Turn Sequence

```
| SHUFFLE & DEAL
|   Shuffle all cards in the deck.
|   Deal 4 cards (or all if deck < 4) to player's hand.
|   AI gets 4 face-down cards (purely cosmetic — same count as player).
|   Remaining cards form the draw pile (shown as a deck stack icon).
|
| LOOP for each turn:
|   1. AI TURN (phase: aiTurn)
|      Pick 1 random card from player's hand as target
|      Show its English translation as the question
|      Phase label: "AI's turn..." with spinner
|      Wait 1.5 seconds
|
|   2. PLAYER TURN (phase: playerTurn)
|      Start 10s timer
|      Phase label: "Your turn! Pick the matching card."
|      Player picks a Chinese char card from hand
|      Correct → card discarded, AI takes 1-3 damage (speed-based)
|               Draw 1 from remaining pile (if hand < 4)
|      Wrong → player takes 1 damage, card stays in hand
|               No draw (hand stays same, max 4)
|      Timeout → player takes 1 damage, card stays in hand
|                No draw
|
|   3. RESULT SHOWN (phase: resultShown)
|      Show result message (green for correct, red for wrong)
|      Animate card colors (glow green/red)
|      Wait 1.2s (correct) or 1.5s (wrong/timeout)
|      Advance to next turn or end game
|
| NEXT TURN:
|   If hand < 4: draw 1 card from remaining pile (if any)
|   If hand ≥ 4: no draw (max hand size enforced)
|   Increment turn number
|   Go to step 1 (AI turn)
|
| GAME OVER when:
|   - AI HP ≤ 0 → Player wins
|   - Player HP ≤ 0 → Player loses
|   - No cards left (hand + deck empty) → Player wins
|   - Deck has no cards at start → Game over immediately with error message
```

## Phase Transitions

```
startGame() → _startAiTurn()
  _startAiTurn()
    → phase = aiTurn, pick question, notifyListeners()
    → Future.delayed(1.5s) → _startPlayerTurn()

_startPlayerTurn()
    → phase = playerTurn, start timer, notifyListeners()

selectCard() / _onTimeout()
    → phase = resultShown, show result, notifyListeners()
    → Future.delayed(1.2-1.5s) → check game over → _advanceTurn()

_advanceTurn()
    → draw 1 card from remaining pile
    → check if hand+deck empty → _endGame()
    → _startAiTurn()
```

**Safety guards:**
- `selectCard()` only processes if `phase == playerTurn`
- `_onTimeout()` only fires if `phase == playerTurn`
- `_advanceTurn()` only fires if `phase == resultShown`
- All game-over paths: check `_disposed` before any mutation

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
| aiTurnDuration | 1.5s | Time AI spends revealing the question |
| resultDelayCorrect | 1.2s | Delay before next turn after correct answer |
| resultDelayWrong | 1.5s | Delay before next turn after wrong answer/timeout |
| maxHandSize | 4 | Max cards visible in player's hand |

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

| Name | Shows | Player picks |
|------|-------|--------------|
| translation→word | Translation (English) on enemy card | Chinese char(s) from hand |
| word→translation | Chinese char(s) on enemy card | Translation from hand (future) |
| cloze | Sentence with blank on enemy card | Missing word from hand (future) |

### Wrong Answer Feedback

When the player answers incorrectly, the result message is simply `'Wrong!'` — **no correct answer is revealed**. This keeps the game challenging and encourages the player to learn through repetition.

## UI Components

### Player Hand Cards

- Fixed width: **100px** (increased from 80px for better readability)
- Height: 150px
- Hearthstone-style: accent bar at top, Chinese character (28px), divider line, pinyin
- Dark theme friendly gradient (surfaceContainerHigh → surfaceContainerHighest)
- Tappable during `playerTurn` (scale animation on tap)
- Result color highlights: green border/glow for correct, red for wrong
- **Max 4 cards visible** — hand size capped; extra cards stay in draw pile

### Deck Stack

Shown in the bottom info row as a small icon + number:
- Icon: `Icons.style` (stack of cards)
- Label: remaining card count (e.g., "12")
- When remaining == 0: shows "0" (empty draw pile)
- This replaces the previous "Cards: X" total counter

### Enemy Hand (Face-Down Cards)

Cosmetic only. Shown above the question area (below AI HP bar):
- **4 face-down cards** in a fan/spread layout
- Each card: 44×54px, grey gradient (dark/light mode aware)
- Slight rotation stagger (±0.04 rad per card from center)
- Slight Y-offset on edges for a 3D fan/spread
- Card back shows `Icons.help_outline` icon in center
- Borders subtle (white 30% alpha in dark mode, black 20% in light)
- Same count as player's initial hand (min(4, deck size))

### Enemy Question Card

Styled like a player card but with **enemy (red/dark) theme**:
- Red gradient (shade800 → shade900)
- Top accent bar: red gradient with a ⚔ icon and "ENEMY" label
- Body: mode label, English translation text (22px, white), bottom accent line
- Card width: 260px
- Border color: red.shade700 (default), green/red on resultShown
- Shadow glow matches result color (green for correct answer revealed, red for wrong)

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
enum GamePhase { aiTurn, playerTurn, resultShown, gameOver }

class GameState {
  List<WordCard> playerHand;
  List<WordCard> remainingCards;       // cards not yet drawn (draw pile)
  int enemyHandSize;                   // cards shown face-down for AI (cosmetic)
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
| `startGame()` | Load cards from DB, shuffle, deal 4, create GameSession in Isar, start AI turn |
| `_startAiTurn()` | Pick question from hand, set phase=aiTurn, 1.5s delay → playerTurn |
| `_startPlayerTurn()` | Set phase=playerTurn, start 10s timer |
| `selectCard()` | Evaluate answer, calculate damage, show result or end game |
| `_handleCorrectAnswer()` | Remove card from hand, deal damage, set phase=resultShown |
| `_handleWrongAnswer()` | Player takes 1 damage, set phase=resultShown |
| `_onTimeout()` | Handle 10s timeout — player takes 1 damage |
| `_advanceTurn()` | Draw 1 from pile, start next AI turn |
| `_endGame()` | Cancel timer, save GameSession to Isar as completed |
| `restart()` | Reset and call startGame with same deck/mode |

### Timer

- Uses `Timer.periodic(const Duration(seconds: 1))` to count down from 10
- Timer ticks update `timerSecondsRemaining` in state
- At 0: calls `_onTimeout()` (only if phase == playerTurn)
- Cancelled on: player input (`selectCard`), timeout, game over, dispose

### Race Condition Guards

The game uses phase-based guards to prevent stale callbacks:

1. **`selectCard()`** — only processes if `phase == playerTurn`
2. **`_onTimeout()`** — only fires if `phase == playerTurn`
3. **`_advanceTurn()`** — only fires if `phase == resultShown` (prevents stale Future.delayed from a previous turn)
4. **All game mutations** — check `_disposed` before any state change

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

## UI Phase Indicators (GameBattlePage)

The question area shows context-appropriate labels per phase:

| Phase | Label | Timer | Cards |
|-------|-------|-------|-------|
| aiTurn | "AI's turn..." (spinner) | Hidden | Non-tappable |
| playerTurn | "Your turn! Pick the matching card." | Visible, counting down | Tappable |
| resultShown | Result message (green/red) | Hidden | Non-tappable, color-highlighted |
| gameOver | — | Hidden | Non-tappable, game over sheet shown |

## AI Opponent

**MVP implementation:**
- AI turn is purely visual — reveals the question with a 1.5s animation
- AI "asks" by picking a **random card from the player's hand** as the target question
- AI "attacks" if player times out (1 damage to player)
- AI "attacks" if player picks wrong card (1 damage to player)
- No strategy or adaptation
- AI always starts with 10 HP and never regenerates
- AI has a **cosmetic hand** of face-down cards (4 card backs above the question area)
