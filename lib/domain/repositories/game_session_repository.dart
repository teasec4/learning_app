import 'package:learning_app/domain/entities/game_session.dart';

abstract class GameSessionRepository {
  Future<List<GameSession>> getAll();
  Future<GameSession?> getById(int id);
  Future<int> create(GameSession session);
  Future<void> update(GameSession session);
  Future<void> delete(int id);
  Future<int> getTotalCount();
}
