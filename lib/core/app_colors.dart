import 'package:flutter/animation.dart';

class AppColors {
  // ── Primary seed ──
  static const Color primary = Color(0xFF059669);
  static const Color primaryDark = Color(0xFF047857);

  // ── Deck card palette (8 colors for auto-assignment) ──
  static const List<Color> deckColors = [
    Color(0xFF059669), // emerald
    Color(0xFF0284C7), // sky blue
    Color(0xFF7C3AED), // violet
    Color(0xFFDC2626), // red
    Color(0xFFD97706), // amber
    Color(0xFF0891B2), // cyan
    Color(0xFFDB2777), // pink
    Color(0xFF65A30D), // lime
  ];

  static Color deckColor(int index) {
    return deckColors[index % deckColors.length];
  }

  // ── Deck card background gradients (same order as deckColors) ──
  static const List<List<Color>> deckGradients = [
    [Color(0xFF059669), Color(0xFF047857)],
    [Color(0xFF0284C7), Color(0xFF0369A1)],
    [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    [Color(0xFFDC2626), Color(0xFFB91C1C)],
    [Color(0xFFD97706), Color(0xFFB45309)],
    [Color(0xFF0891B2), Color(0xFF0E7490)],
    [Color(0xFFDB2777), Color(0xFFBE185D)],
    [Color(0xFF65A30D), Color(0xFF4D7C0F)],
  ];

  static List<Color> deckGradient(int index) {
    return deckGradients[index % deckGradients.length];
  }

  // ── Status ──
  static const Color success = Color(0xFF16A34A);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFD97706);
}
