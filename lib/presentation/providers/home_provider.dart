import 'package:flutter/foundation.dart';
import 'package:learning_app/domain/repositories/word_card_repository.dart';

class HomeProvider extends ChangeNotifier {
  final WordCardRepository _repository;

  int _totalCards = 0;
  bool _isLoading = false;

  HomeProvider(this._repository);

  int get totalCards => _totalCards;
  bool get isLoading => _isLoading;
  int get level => (_totalCards / 10).floor() + 1;
  int get xp => _totalCards % 10;
  int get xpToNextLevel => 10;

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    _totalCards = await _repository.getTotalCount();

    _isLoading = false;
    notifyListeners();
  }
}
