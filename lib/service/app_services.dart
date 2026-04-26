import 'package:learning_app/data/datasources/database.dart';
import 'package:learning_app/domain/repositories/deck_repository.dart';
import 'package:learning_app/domain/repositories/word_card_repository.dart';
import 'package:learning_app/domain/repositories/game_session_repository.dart';
import 'package:learning_app/data/repositories/deck_repository_impl.dart';
import 'package:learning_app/data/repositories/word_card_repository_impl.dart';
import 'package:learning_app/data/repositories/game_session_repository_impl.dart';

class AppServices {
  late final DatabaseService database;
  late final DeckRepository deckRepository;
  late final WordCardRepository wordCardRepository;
  late final GameSessionRepository gameSessionRepository;

  static final AppServices _instance = AppServices._internal();
  factory AppServices() => _instance;
  AppServices._internal();

  Future<void> init() async {
    database = DatabaseService();
    await database.init();

    deckRepository = DeckRepositoryImpl(database);
    wordCardRepository = WordCardRepositoryImpl(database);
    gameSessionRepository = GameSessionRepositoryImpl(database);
  }
}
