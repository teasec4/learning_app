class GameSession {
  final int id;
  final int? deckId;
  final String? deckName;
  final GameType gameType;
  final GameStatus status;
  final int score;
  final int correctCount;
  final int totalCards;
  final DateTime startedAt;
  final DateTime? completedAt;

  const GameSession({
    this.id = 0,
    this.deckId,
    this.deckName,
    required this.gameType,
    this.status = GameStatus.inProgress,
    this.score = 0,
    this.correctCount = 0,
    this.totalCards = 0,
    required this.startedAt,
    this.completedAt,
  });
}

enum GameType {
  flashcards,
  duel,
  cloze,
  dragMatch;

  String get displayName {
    switch (this) {
      case GameType.flashcards:
        return "Флэшкарты";
      case GameType.duel:
        return "Дуэль";
      case GameType.cloze:
        return "Вставь слово";
      case GameType.dragMatch:
        return "Найди пару";
    }
  }

  String get icon {
    switch (this) {
      case GameType.flashcards:
        return "🃏";
      case GameType.duel:
        return "⚔️";
      case GameType.cloze:
        return "✍️";
      case GameType.dragMatch:
        return "🔗";
    }
  }
}

enum GameStatus {
  inProgress,
  completed,
  abandoned;
}
