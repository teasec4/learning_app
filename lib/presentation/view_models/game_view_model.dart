import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:learning_app/domain/entities/deck.dart';
import 'package:learning_app/domain/entities/word_card.dart';
import 'package:learning_app/domain/entities/game_session.dart';
import 'package:learning_app/domain/entities/game_state.dart';
import 'package:learning_app/domain/entities/game_mode.dart';
import 'package:learning_app/domain/repositories/word_card_repository.dart';
import 'package:learning_app/domain/repositories/game_session_repository.dart';
import 'package:learning_app/service/app_services.dart';

class GameResult {
  final bool playerWon;
  final int score;
  final int correctCount;
  final int totalCards;
  final int turnsPlayed;

  const GameResult({
    required this.playerWon,
    required this.score,
    required this.correctCount,
    required this.totalCards,
    required this.turnsPlayed,
  });
}

class GameViewModel extends ChangeNotifier {
  final WordCardRepository _wordCardRepository;
  final GameSessionRepository _gameSessionRepository;
  final Random _random = Random();

  GameState _state = _emptyState();
  GameSession? _currentSession;
  Timer? _timer;
  bool _disposed = false;

  GameViewModel()
      : _wordCardRepository = AppServices().wordCardRepository,
        _gameSessionRepository = AppServices().gameSessionRepository;

  GameState get state => _state;
  bool get isDisposed => _disposed;

  static GameState _emptyState() {
    return GameState(
      playerHand: [],
      remainingCards: [],
      deck: Deck(id: 0, name: '', createdAt: DateTime(0), updatedAt: DateTime(0)),
      mode: GameMode.translationToWord,
    );
  }

  Future<void> startGame(Deck deck, GameMode mode) async {
    final cards = await _wordCardRepository.getAll(deck.id);

    if (cards.isEmpty) {
      _state = _state.copyWith(
        phase: GamePhase.gameOver,
        resultMessage: 'This deck has no cards! Add some cards first.',
      );
      notifyListeners();
      return;
    }

    // Shuffle and deal
    cards.shuffle(_random);
    final handSize = min(4, cards.length);
    final hand = cards.take(handSize).toList();
    final remaining = cards.skip(handSize).toList();

    _state = GameState(
      playerHand: hand,
      remainingCards: remaining,
      deck: deck,
      mode: mode,
      playerHp: 10,
      aiHp: 10,
      totalCards: cards.length,
      phase: GamePhase.waitingForAnswer,
    );

    // Create GameSession in DB
    final now = DateTime.now();
    _currentSession = GameSession(
      id: 0,
      deckId: deck.id,
      deckName: deck.name,
      gameType: GameType.duel,
      status: GameStatus.inProgress,
      score: 0,
      correctCount: 0,
      totalCards: cards.length,
      startedAt: now,
    );
    final sessionId = await _gameSessionRepository.create(_currentSession!);
    _currentSession = GameSession(
      id: sessionId,
      deckId: deck.id,
      deckName: deck.name,
      gameType: GameType.duel,
      status: GameStatus.inProgress,
      score: 0,
      correctCount: 0,
      totalCards: cards.length,
      startedAt: now,
    );

    _pickQuestion();
    _startTimer();
    notifyListeners();
  }

  void selectCard(WordCard card) {
    if (_state.phase != GamePhase.waitingForAnswer || _disposed) return;
    if (_state.currentQuestion == null) return;

    _timer?.cancel();

    final elapsed = DateTime.now().difference(_state.turnStartTime!).inSeconds;
    final isCorrect = card.word == _state.currentQuestion!.word;

    if (isCorrect) {
      final damage = _calculateDamage(elapsed);
      final newAiHp = (_state.aiHp - damage).clamp(0, 10);

      // Remove the used card from hand
      final updatedHand = List<WordCard>.from(_state.playerHand)
        ..removeWhere((c) => c.word == card.word);

      _state = _state.copyWith(
        playerHand: updatedHand,
        score: _state.score + damage,
        correctCount: _state.correctCount + 1,
        aiHp: newAiHp,
        phase: GamePhase.showingResult,
        lastAnswerCorrect: true,
        resultMessage: '+$damage HP! ${card.word}',
      );
      notifyListeners();

      if (newAiHp <= 0) {
        _endGame(playerWon: true);
        return;
      }

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!_disposed) _advanceTurn();
      });
    } else {
      final newHp = (_state.playerHp - 1).clamp(0, 10);

      _state = _state.copyWith(
        playerHp: newHp,
        phase: GamePhase.showingResult,
        lastAnswerCorrect: false,
        resultMessage: 'Wrong! It was ${_state.currentQuestion!.word}',
      );
      notifyListeners();

      if (newHp <= 0) {
        _endGame(playerWon: false);
        return;
      }

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!_disposed) _advanceTurn();
      });
    }
  }

  void _advanceTurn() {
    if (_disposed) return;

    // Draw one card from remaining pile
    final remaining = List<WordCard>.from(_state.remainingCards);
    final hand = List<WordCard>.from(_state.playerHand);

    if (remaining.isNotEmpty) {
      hand.add(remaining.removeAt(0));
    }

    // Check if game is over due to no cards
    if (hand.isEmpty && remaining.isEmpty) {
      _endGame(playerWon: true);
      return;
    }

    _state = _state.copyWith(
      playerHand: hand,
      remainingCards: remaining,
      turnNumber: _state.turnNumber + 1,
      clearCurrentQuestion: true,
      clearLastAnswer: true,
    );

    _pickQuestion();
    _startTimer();
    notifyListeners();
  }

  void _pickQuestion() {
    final hand = _state.playerHand;
    if (hand.isEmpty) return;

    // Pick a random card from hand to be the target question
    final target = hand[_random.nextInt(hand.length)];
    _state = _state.copyWith(currentQuestion: target);
  }

  int _calculateDamage(int elapsedSeconds) {
    // Linear damage: faster → more damage
    // 0s → 3, 5s → 2, 10s → 1
    final clamped = elapsedSeconds.clamp(0, 10);
    final damage = 3 - 2 * (clamped / 10);
    return damage.round().clamp(1, 3);
  }

  void _startTimer() {
    _state = _state.copyWith(
      timerSecondsRemaining: 10,
      turnStartTime: DateTime.now(),
    );
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      final remaining = _state.timerSecondsRemaining - 1;
      _state = _state.copyWith(timerSecondsRemaining: remaining);
      notifyListeners();

      if (remaining <= 0) {
        timer.cancel();
        _onTimeout();
      }
    });
  }

  void _onTimeout() {
    if (_state.phase != GamePhase.waitingForAnswer || _disposed) return;

    final newHp = (_state.playerHp - 1).clamp(0, 10);
    _state = _state.copyWith(
      playerHp: newHp,
      phase: GamePhase.showingResult,
      lastAnswerCorrect: false,
      resultMessage: 'Time\'s up! It was ${_state.currentQuestion?.word ?? '?'}',
    );
    notifyListeners();

    if (newHp <= 0) {
      _endGame(playerWon: false);
      return;
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!_disposed) _advanceTurn();
    });
  }

  void _endGame({required bool playerWon}) {
    _timer?.cancel();

    _state = _state.copyWith(
      phase: GamePhase.gameOver,
      resultMessage: playerWon
          ? 'You Win! 🎉'
          : 'You Lose! 😵',
    );
    notifyListeners();

    // Save final GameSession in DB
    if (_currentSession != null) {
      _gameSessionRepository.update(
        GameSession(
          id: _currentSession!.id,
          deckId: _currentSession!.deckId,
          deckName: _currentSession!.deckName,
          gameType: GameType.duel,
          status: GameStatus.completed,
          score: _state.score,
          correctCount: _state.correctCount,
          totalCards: _state.totalCards,
          startedAt: _currentSession!.startedAt,
          completedAt: DateTime.now(),
        ),
      );
    }
  }

  void restart() {
    _timer?.cancel();
    startGame(_state.deck, _state.mode);
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
