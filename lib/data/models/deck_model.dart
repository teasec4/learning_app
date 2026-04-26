import 'package:isar_community/isar.dart';

part 'deck_model.g.dart';

@collection
class DeckModel {
  Id id = Isar.autoIncrement;

  late String name;

  String? description;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;
}
