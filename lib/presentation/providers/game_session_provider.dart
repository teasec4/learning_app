import 'package:flutter/foundation.dart';
import 'package:learning_app/domain/entities/game_session.dart';
import 'package:learning_app/domain/repositories/game_session_repository.dart';

class GameSessionProvider extends ChangeNotifier {
  final GameSessionRepository _repository;

  List<GameSession> _sessions = [];
  int _totalSessions = 0;

  GameSessionProvider(this._repository);

  List<GameSession> get sessions => _sessions;
  int get totalSessions => _totalSessions;

  Future<void> loadSessions() async {
    _sessions = await _repository.getAll();
    _totalSessions = await _repository.getTotalCount();
    notifyListeners();
  }

  Future<int> createSession(GameSession session) async {
    final id = await _repository.create(session);
    await loadSessions();
    return id;
  }

  Future<void> updateSession(GameSession session) async {
    await _repository.update(session);
    await loadSessions();
  }
}
