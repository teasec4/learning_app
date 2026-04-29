import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/domain/entities/game_mode.dart';
import 'package:learning_app/route/router.dart';
import 'package:go_router/go_router.dart';

class GameLobbyPage extends StatefulWidget {
  const GameLobbyPage({super.key});

  @override
  State<GameLobbyPage> createState() => _GameLobbyPageState();
}

class _GameLobbyPageState extends State<GameLobbyPage> {
  int? _selectedDeckId;
  GameMode _selectedMode = GameMode.translationToWord;

  @override
  Widget build(BuildContext context) {
    final deckProvider = context.watch<DeckProvider>();
    final decks = deckProvider.decks;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duel'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Deck selector ──
                Text(
                  'Deck',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  initialValue: _selectedDeckId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select a deck',
                  ),
                  items: decks.map((deck) => DropdownMenuItem(
                    value: deck.id,
                    child: Text('${deck.name} (${deck.cardCount} cards)'),
                  )).toList(),
                  onChanged: (v) => setState(() => _selectedDeckId = v),
                ),
                if (decks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Create a deck on the Decks tab first',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // ── Game mode selector ──
                Text(
                  'Mode',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Mode card — currently only one mode, but UI prepared for expansion
                _buildModeCard(
                  context,
                  mode: GameMode.translationToWord,
                  isSelected: _selectedMode == GameMode.translationToWord,
                  onTap: () => setState(() => _selectedMode = GameMode.translationToWord),
                ),
              ],
            ),
          ),

          // ── Start battle button ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _selectedDeckId != null
                      ? () {
                          final deck = decks.firstWhere((d) => d.id == _selectedDeckId);
                          context.push(
                            AppRoutes.gameBattle(deck.id),
                            extra: {'mode': _selectedMode},
                          );
                        }
                      : null,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Battle!', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required GameMode mode,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;

    return Card(
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('⚔️', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.displayName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode.description,
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
    );
  }
}
