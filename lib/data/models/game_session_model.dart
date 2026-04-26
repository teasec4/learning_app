import 'package:isar_community/isar.dart';

part 'game_session_model.g.dart';

@collection
class GameSessionModel {
  Id id = Isar.autoIncrement;

  int? deckId;
  String? deckName;

  late String gameType;

  late String status;

  int score = 0;
  int correctCount = 0;
  int totalCards = 0;

  late DateTime startedAt;
  DateTime? completedAt;
}
