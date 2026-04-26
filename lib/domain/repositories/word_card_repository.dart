import 'package:learning_app/domain/entities/word_card.dart';

abstract class WordCardRepository {
  Future<List<WordCard>> getAll(int deckId);
  Future<WordCard?> getById(int id);
  Future<int> create(WordCard card);
  Future<void> update(WordCard card);
  Future<void> delete(int id);
  Future<int> getTotalCount();
}
