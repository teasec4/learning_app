enum GameMode {
  /// Show English translation → player picks matching Chinese character
  translationToWord;

  String get displayName {
    switch (this) {
      case GameMode.translationToWord:
        return 'Translation → Character';
    }
  }

  String get description {
    switch (this) {
      case GameMode.translationToWord:
        return 'See the translation, pick the matching Chinese character.';
    }
  }
}
