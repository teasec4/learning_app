import 'package:isar_community/isar.dart';
import 'package:learning_app/domain/entities/game_session.dart';
import 'package:learning_app/domain/repositories/game_session_repository.dart';
import 'package:learning_app/data/models/game_session_model.dart';
import 'package:learning_app/data/datasources/database.dart';

class GameSessionRepositoryImpl implements GameSessionRepository {
  final DatabaseService _db;

  GameSessionRepositoryImpl(this._db);

  @override
  Future<List<GameSession>> getAll() async {
    final models = await _db.isar.gameSessionModels
        .where()
        .sortByStartedAtDesc()
        .findAll();
    return models.map(_toEntity).toList();
  }

  @override
  Future<GameSession?> getById(int id) async {
    final model = await _db.isar.gameSessionModels.get(id);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<int> create(GameSession session) async {
    final model = _toModel(session);
    return _db.isar.writeTxn(() async {
      return _db.isar.gameSessionModels.put(model);
    });
  }

  @override
  Future<void> update(GameSession session) async {
    final model = _toModel(session);
    await _db.isar.writeTxn(() async {
      await _db.isar.gameSessionModels.put(model);
    });
  }

  @override
  Future<void> delete(int id) async {
    await _db.isar.writeTxn(() async {
      await _db.isar.gameSessionModels.delete(id);
    });
  }

  @override
  Future<int> getTotalCount() async {
    return _db.isar.gameSessionModels.where().count();
  }

  GameSession _toEntity(GameSessionModel model) {
    return GameSession(
      id: model.id,
      deckId: model.deckId,
      deckName: model.deckName,
      gameType: GameType.values.firstWhere(
        (e) => e.name == model.gameType,
        orElse: () => GameType.flashcards,
      ),
      status: GameStatus.values.firstWhere(
        (e) => e.name == model.status,
        orElse: () => GameStatus.inProgress,
      ),
      score: model.score,
      correctCount: model.correctCount,
      totalCards: model.totalCards,
      startedAt: model.startedAt,
      completedAt: model.completedAt,
    );
  }

  GameSessionModel _toModel(GameSession session) {
    return GameSessionModel()
      ..id = session.id
      ..deckId = session.deckId
      ..deckName = session.deckName
      ..gameType = session.gameType.name
      ..status = session.status.name
      ..score = session.score
      ..correctCount = session.correctCount
      ..totalCards = session.totalCards
      ..startedAt = session.startedAt
      ..completedAt = session.completedAt;
  }
}
