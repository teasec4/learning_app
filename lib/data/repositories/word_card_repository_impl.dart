import 'package:isar_community/isar.dart';
import 'package:learning_app/domain/entities/word_card.dart';
import 'package:learning_app/domain/repositories/word_card_repository.dart';
import 'package:learning_app/data/models/word_card_model.dart';
import 'package:learning_app/data/datasources/database.dart';

class WordCardRepositoryImpl implements WordCardRepository {
  final DatabaseService _db;

  WordCardRepositoryImpl(this._db);

  @override
  Future<List<WordCard>> getAll(int deckId) async {
    final models = await _db.isar.wordCardModels
        .filter()
        .deckIdEqualTo(deckId)
        .sortByCreatedAtDesc()
        .findAll();
    return models.map(_toEntity).toList();
  }

  @override
  Future<WordCard?> getById(int id) async {
    final model = await _db.isar.wordCardModels.get(id);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<int> create(WordCard card) async {
    final model = _toModel(card);
    return _db.isar.writeTxn(() async {
      return _db.isar.wordCardModels.put(model);
    });
  }

  @override
  Future<void> update(WordCard card) async {
    final model = _toModel(card);
    await _db.isar.writeTxn(() async {
      await _db.isar.wordCardModels.put(model);
    });
  }

  @override
  Future<void> delete(int id) async {
    await _db.isar.writeTxn(() async {
      await _db.isar.wordCardModels.delete(id);
    });
  }

  @override
  Future<int> getTotalCount() async {
    return _db.isar.wordCardModels.where().count();
  }

  WordCard _toEntity(WordCardModel model) {
    return WordCard(
      id: model.id,
      deckId: model.deckId,
      word: model.word,
      pinyin: model.pinyin,
      translation: model.translation,
      contextSentence: model.contextSentence,
      notes: model.notes,
      source: model.source,
      createdAt: model.createdAt,
    );
  }

  WordCardModel _toModel(WordCard card) {
    return WordCardModel()
      ..id = card.id
      ..deckId = card.deckId
      ..word = card.word
      ..pinyin = card.pinyin
      ..translation = card.translation
      ..contextSentence = card.contextSentence
      ..notes = card.notes
      ..source = card.source
      ..createdAt = card.createdAt;
  }
}
