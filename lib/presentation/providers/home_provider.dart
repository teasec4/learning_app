import 'package:flutter/foundation.dart';
import 'package:learning_app/domain/entities/game_session.dart';
import 'package:learning_app/domain/repositories/word_card_repository.dart';
import 'package:learning_app/domain/repositories/game_session_repository.dart';

class HomeProvider extends ChangeNotifier {
  final WordCardRepository _wordCardRepository;
  final GameSessionRepository _gameSessionRepository;

  int _totalCards = 0;
  List<GameSession> _sessions = [];
  bool _isLoading = false;

  HomeProvider(this._wordCardRepository, this._gameSessionRepository);

  int get totalCards => _totalCards;
  bool get isLoading => _isLoading;

  List<GameSession> get sessions => _sessions;
  int get totalGames =>
      _sessions.where((s) => s.status == GameStatus.completed).length;
  int get totalScore =>
      _sessions.fold(0, (sum, s) => sum + s.score);
  int get totalCorrect =>
      _sessions.fold(0, (sum, s) => sum + s.correctCount);
  int get totalCardsPlayed =>
      _sessions.fold(0, (sum, s) => sum + s.totalCards);

  /// XP = total accumulated score from all completed games
  int get xp => totalScore;

  /// Level up every 100 XP
  int get level => (xp ~/ 100) + 1;

  /// XP earned within the current level (0-99)
  int get xpInLevel => xp % 100;

  /// XP needed to reach the next level
  int get xpToNextLevel => 100;

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    _totalCards = await _wordCardRepository.getTotalCount();
    _sessions = await _gameSessionRepository.getAll();

    _isLoading = false;
    notifyListeners();
  }
}
