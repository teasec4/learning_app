import 'package:flutter/foundation.dart';
import 'package:learning_app/domain/repositories/word_card_repository.dart';

class HomeProvider extends ChangeNotifier {
  final WordCardRepository _repository;

  int _totalCards = 0;

  HomeProvider(this._repository);

  int get totalCards => _totalCards;
  int get level => (_totalCards / 10).floor() + 1;
  int get xp => _totalCards % 10;
  int get xpToNextLevel => 10;

  Future<void> refresh() async {
    _totalCards = await _repository.getTotalCount();
    notifyListeners();
  }
}
