import 'package:flutter/foundation.dart';
import 'package:learning_app/domain/entities/deck.dart';
import 'package:learning_app/domain/repositories/deck_repository.dart';

class DeckProvider extends ChangeNotifier {
  final DeckRepository _repository;

  List<Deck> _decks = [];
  bool _isLoading = false;

  DeckProvider(this._repository);

  List<Deck> get decks => _decks;
  bool get isLoading => _isLoading;

  Future<void> loadDecks() async {
    _isLoading = true;
    notifyListeners();

    _decks = await _repository.getAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<int> createDeck(String name, {String? description}) async {
    final now = DateTime.now();
    final deck = Deck(
      id: 0,
      name: name,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
    final id = await _repository.create(deck);
    await loadDecks();
    return id;
  }

  Future<void> renameDeck(int id, String newName) async {
    final deck = _decks.firstWhere((d) => d.id == id);
    final updated = Deck(
      id: deck.id,
      name: newName,
      description: deck.description,
      createdAt: deck.createdAt,
      updatedAt: DateTime.now(),
    );
    await _repository.update(updated);
    await loadDecks();
  }

  Future<void> deleteDeck(int id) async {
    await _repository.delete(id);
    await loadDecks();
  }

  Future<void> refreshCardCounts() async {
    _decks = await _repository.getAll();
    notifyListeners();
  }
}
