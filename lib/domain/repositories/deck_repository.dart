import 'package:learning_app/domain/entities/deck.dart';

abstract class DeckRepository {
  Future<List<Deck>> getAll();
  Future<Deck?> getById(int id);
  Future<int> create(Deck deck);
  Future<void> update(Deck deck);
  Future<void> delete(int id);
  Future<int> getCardCount(int deckId);
}
