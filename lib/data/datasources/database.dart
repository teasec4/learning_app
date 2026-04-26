import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:learning_app/data/models/deck_model.dart';
import 'package:learning_app/data/models/word_card_model.dart';

class DatabaseService {
  late Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [DeckModelSchema, WordCardModelSchema],
      directory: dir.path,
    );
  }
}
