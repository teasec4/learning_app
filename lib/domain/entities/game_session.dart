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
  duel;

  String get displayName {
    switch (this) {
      case GameType.duel:
        return "Duel";
    }
  }

  String get icon {
    switch (this) {
      case GameType.duel:
        return "⚔️";
    }
  }
}

enum GameStatus {
  inProgress,
  completed,
  abandoned;
}
