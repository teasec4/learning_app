# Domain Model

## Deck

A collection of word cards. Can be thematic ("Food", "Travel") or arbitrary.

```dart
class Deck {
  final int id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int cardCount;      // computed field (not stored in DB)
}
```

**Isar model:** `DeckModel` — same fields minus `cardCount` (queried via `getCardCount`).

**Repository:**

```dart
abstract class DeckRepository {
  Future<List<Deck>> getAll();
  Future<Deck?> getById(int id);
  Future<int> create(Deck deck);
  Future<void> update(Deck deck);
  Future<void> delete(int id);         // cascading: deletes all WordCards in deck
  Future<int> getCardCount(int deckId);
}
```

## WordCard

A single flashcard. Contains a Chinese character/word, pinyin, and translation.

```dart
class WordCard {
  final int id;
  final int deckId;
  final String word;            // Chinese character(s)
  final String? pinyin;         // pinyin transcription
  final String translation;     // translation (English)
  final String? contextSentence;
  final String? notes;
  final String? source;
  final DateTime createdAt;
}
```

**Repository:**

```dart
abstract class WordCardRepository {
  Future<List<WordCard>> getAll(int deckId);
  Future<WordCard?> getById(int id);
  Future<int> create(WordCard card);
  Future<void> update(WordCard card);
  Future<void> delete(int id);
  Future<int> getTotalCount();         // total cards across all decks
}
```

## GameSession

A completed or in-progress battle. Saved after each game.

```dart
class GameSession {
  final int id;                  // default: 0 (Isar autoIncrement)
  final int? deckId;
  final String? deckName;
  final GameType gameType;
  final GameStatus status;       // default: GameStatus.inProgress
  final int score;               // default: 0
  final int correctCount;        // default: 0
  final int totalCards;          // default: 0
  final DateTime startedAt;
  final DateTime? completedAt;
}
```

### GameType

```dart
enum GameType {
  duel;   // Hearthstone-like battle (the only active mode)

  String get displayName => switch (this) {
    GameType.duel => "Duel",
  };
  String get icon => switch (this) {
    GameType.duel => "⚔️",
  };
}
```

Future question modes (parameter of duel engine, NOT separate GameTypes):

| Mode | Shows | Player picks |
|------|-------|--------------|
| translation→word | Translation | Chinese character(s) from hand |
| word→translation | Chinese character(s) | Translation from hand |
| cloze | Sentence with blank | Missing word from hand |

### GameStatus

```dart
enum GameStatus {
  inProgress,
  completed,
  abandoned;
}
```

## Future Entities (roadmap)

- **UserProfile** — avatar, XP, level, statistics
- **Achievement** — unlockable achievements
- **CardStats** — per-card accuracy (correct/incorrect count)
