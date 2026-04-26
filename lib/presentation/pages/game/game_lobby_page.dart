import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/domain/entities/game_session.dart';

class GameLobbyPage extends StatefulWidget {
  const GameLobbyPage({super.key});

  @override
  State<GameLobbyPage> createState() => _GameLobbyPageState();
}

class _GameLobbyPageState extends State<GameLobbyPage> {
  int? _selectedDeckId;
  GameType? _selectedMode;

  static const _modes = [
    (GameType.flashcards, "Флэшкарты", "🃏", "Листай карточки\nи вспоминай перевод"),
    (GameType.duel, "Дуэль", "⚔️", "Сражайся словами\nпротив AI"),
    (GameType.cloze, "Вставь слово", "✍️", "Дополни пропуск\nв предложении"),
    (GameType.dragMatch, "Найди пару", "🔗", "Соедини слово\nс переводом"),
  ];

  @override
  Widget build(BuildContext context) {
    final deckProvider = context.watch<DeckProvider>();
    final decks = deckProvider.decks;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Выбор игры"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // --- Выбор колоды ---
                Text(
                  "Колода",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  initialValue: _selectedDeckId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Все карточки",
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Все карточки"),
                    ),
                    ...decks.map((deck) => DropdownMenuItem(
                      value: deck.id,
                      child: Text(deck.name),
                    )),
                  ],
                  onChanged: (v) => setState(() => _selectedDeckId = v),
                ),
                const SizedBox(height: 24),

                // --- Выбор режима ---
                Text(
                  "Режим игры",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ..._modes.map((mode) => _ModeCard(
                  type: mode.$1,
                  title: mode.$2,
                  emoji: mode.$3,
                  subtitle: mode.$4,
                  isSelected: _selectedMode == mode.$1,
                  onTap: () => setState(() => _selectedMode = mode.$1),
                )),
              ],
            ),
          ),

          // --- Кнопка Старт ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _selectedMode != null
                      ? () => _onStart(context)
                      : null,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text("Начать!", style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onStart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Режим «${_selectedMode!.displayName}» — скоро!"),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final GameType type;
  final String title;
  final String emoji;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.type,
    required this.title,
    required this.emoji,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: isSelected ? 2 : 1),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: theme.colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
