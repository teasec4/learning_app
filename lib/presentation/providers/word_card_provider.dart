import 'package:flutter/foundation.dart';
import 'package:learning_app/domain/entities/word_card.dart';
import 'package:learning_app/domain/repositories/word_card_repository.dart';

class WordCardProvider extends ChangeNotifier {
  final WordCardRepository _repository;

  List<WordCard> _cards = [];
  bool _isLoading = false;

  WordCardProvider(this._repository);

  List<WordCard> get cards => _cards;
  bool get isLoading => _isLoading;

  Future<void> loadCards(int deckId) async {
    _isLoading = true;
    notifyListeners();

    _cards = await _repository.getAll(deckId);

    _isLoading = false;
    notifyListeners();
  }

  Future<int> addCard({
    required int deckId,
    required String word,
    String? pinyin,
    required String translation,
    String? contextSentence,
    String? notes,
    String? source,
  }) async {
    final card = WordCard(
      id: 0,
      deckId: deckId,
      word: word,
      pinyin: pinyin,
      translation: translation,
      contextSentence: contextSentence,
      notes: notes,
      source: source,
      createdAt: DateTime.now(),
    );
    final id = await _repository.create(card);
    await loadCards(deckId);
    return id;
  }

  Future<void> updateCard(WordCard card) async {
    await _repository.update(card);
    await loadCards(card.deckId);
  }

  Future<void> deleteCard(int id, int deckId) async {
    await _repository.delete(id);
    await loadCards(deckId);
  }
}
