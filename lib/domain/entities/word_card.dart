class WordCard {
  final int id;
  final int deckId;
  final String word;
  final String? pinyin;
  final String translation;
  final String? contextSentence;
  final String? notes;
  final String? source;
  final DateTime createdAt;

  WordCard({
    required this.id,
    required this.deckId,
    required this.word,
    this.pinyin,
    required this.translation,
    this.contextSentence,
    this.notes,
    this.source,
    required this.createdAt,
  });
}
