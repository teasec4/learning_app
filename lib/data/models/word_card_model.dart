import 'package:isar_community/isar.dart';

part 'word_card_model.g.dart';

@collection
class WordCardModel {
  Id id = Isar.autoIncrement;

  late int deckId;

  @Index()
  late String word;

  String? pinyin;

  late String translation;

  String? contextSentence;

  String? notes;

  String? source;

  @Index()
  late DateTime createdAt;
}
