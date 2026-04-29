import 'package:learning_app/domain/entities/word_card.dart';
import 'package:learning_app/domain/entities/deck.dart';
import 'package:learning_app/domain/entities/game_mode.dart';

enum GamePhase {
  aiTurn,
  playerTurn,
  resultShown,
  gameOver,
}

class GameState {
  final List<WordCard> playerHand;
  final List<WordCard> remainingCards;
  final int enemyHandSize;          // cards shown face-down for AI (cosmetic only)
  final WordCard? currentQuestion;
  final Deck deck;
  final GameMode mode;
  final int playerHp;
  final int aiHp;
  final int score;
  final int turnNumber;
  final int correctCount;
  final int totalCards;
  final GamePhase phase;
  final DateTime? turnStartTime;
  final int timerSecondsRemaining;
  final bool? lastAnswerCorrect;
  final String? resultMessage;

  const GameState({
    required this.playerHand,
    required this.remainingCards,
    this.enemyHandSize = 4,
    this.currentQuestion,
    required this.deck,
    required this.mode,
    this.playerHp = 10,
    this.aiHp = 10,
    this.score = 0,
    this.turnNumber = 0,
    this.correctCount = 0,
    this.totalCards = 0,
    this.phase = GamePhase.aiTurn,
    this.turnStartTime,
    this.timerSecondsRemaining = 10,
    this.lastAnswerCorrect,
    this.resultMessage,
  });

  GameState copyWith({
    List<WordCard>? playerHand,
    List<WordCard>? remainingCards,
    int? enemyHandSize,
    WordCard? currentQuestion,
    Deck? deck,
    GameMode? mode,
    int? playerHp,
    int? aiHp,
    int? score,
    int? turnNumber,
    int? correctCount,
    int? totalCards,
    GamePhase? phase,
    DateTime? turnStartTime,
    int? timerSecondsRemaining,
    bool? lastAnswerCorrect,
    String? resultMessage,
    bool clearCurrentQuestion = false,
    bool clearLastAnswer = false,
  }) {
    return GameState(
      playerHand: playerHand ?? this.playerHand,
      remainingCards: remainingCards ?? this.remainingCards,
      enemyHandSize: enemyHandSize ?? this.enemyHandSize,
      currentQuestion: clearCurrentQuestion ? null : (currentQuestion ?? this.currentQuestion),
      deck: deck ?? this.deck,
      mode: mode ?? this.mode,
      playerHp: playerHp ?? this.playerHp,
      aiHp: aiHp ?? this.aiHp,
      score: score ?? this.score,
      turnNumber: turnNumber ?? this.turnNumber,
      correctCount: correctCount ?? this.correctCount,
      totalCards: totalCards ?? this.totalCards,
      phase: phase ?? this.phase,
      turnStartTime: turnStartTime ?? this.turnStartTime,
      timerSecondsRemaining: timerSecondsRemaining ?? this.timerSecondsRemaining,
      lastAnswerCorrect: clearLastAnswer ? null : (lastAnswerCorrect ?? this.lastAnswerCorrect),
      resultMessage: clearLastAnswer ? null : (resultMessage ?? this.resultMessage),
    );
  }

  bool get isPlayerAlive => playerHp > 0;
  bool get isAiAlive => aiHp > 0;
}
