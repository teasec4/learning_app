import 'dart:async';
import 'package:isar_community/isar.dart';
import 'package:learning_app/domain/entities/deck.dart';
import 'package:learning_app/domain/repositories/deck_repository.dart';
import 'package:learning_app/data/models/deck_model.dart';
import 'package:learning_app/data/models/word_card_model.dart';
import 'package:learning_app/data/datasources/database.dart';

class DeckRepositoryImpl implements DeckRepository {
  final DatabaseService _db;

  DeckRepositoryImpl(this._db);

  @override
  Future<List<Deck>> getAll() async {
    final models = await _db.isar.deckModels.where().sortByCreatedAtDesc().findAll();
    final decks = <Deck>[];
    for (final model in models) {
      final count = await _db.isar.wordCardModels
          .filter()
          .deckIdEqualTo(model.id)
          .count();
      decks.add(_toEntity(model, count));
    }
    return decks;
  }

  @override
  Future<Deck?> getById(int id) async {
    final model = await _db.isar.deckModels.get(id);
    if (model == null) return null;
    final count = await _db.isar.wordCardModels
        .filter()
        .deckIdEqualTo(id)
        .count();
    return _toEntity(model, count);
  }

  @override
  Future<int> create(Deck deck) async {
    final model = _toModel(deck);
    return _db.isar.writeTxn(() async {
      return _db.isar.deckModels.put(model);
    });
  }

  @override
  Future<void> update(Deck deck) async {
    final model = _toModel(deck);
    await _db.isar.writeTxn(() async {
      await _db.isar.deckModels.put(model);
    });
  }

  @override
  Future<void> delete(int id) async {
    await _db.isar.writeTxn(() async {
      final cards = await _db.isar.wordCardModels
          .filter()
          .deckIdEqualTo(id)
          .findAll();
      await _db.isar.wordCardModels.deleteAll(cards.map((c) => c.id).toList());
      await _db.isar.deckModels.delete(id);
    });
  }

  @override
  Future<int> getCardCount(int deckId) async {
    return _db.isar.wordCardModels
        .filter()
        .deckIdEqualTo(deckId)
        .count();
  }

  @override
  Stream<void> watchDecks() => _db.isar.deckModels.watchLazy();

  @override
  Stream<void> watchCards() => _db.isar.wordCardModels.watchLazy();

  Deck _toEntity(DeckModel model, int cardCount) {
    return Deck(
      id: model.id,
      name: model.name,
      description: model.description,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      cardCount: cardCount,
    );
  }

  DeckModel _toModel(Deck deck) {
    final model = DeckModel()
      ..name = deck.name
      ..description = deck.description
      ..createdAt = deck.createdAt
      ..updatedAt = deck.updatedAt;
    // Only set id for existing decks (update case)
    if (deck.id != 0) {
      model.id = deck.id;
    }
    return model;
  }
}
