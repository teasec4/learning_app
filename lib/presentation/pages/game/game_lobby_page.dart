import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:learning_app/core/app_colors.dart';
import 'package:learning_app/core/app_theme.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/domain/entities/deck.dart';
import 'package:learning_app/domain/entities/game_mode.dart';
import 'package:learning_app/route/router.dart';

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
    final theme = Theme.of(context);
    final deckProvider = context.watch<DeckProvider>();
    final decks = deckProvider.decks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duel'),
      ),
      body: decks.isEmpty ? _buildEmptyState(theme) : _buildContent(theme, decks),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_esports_rounded,
              size: 72,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No decks yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Create a deck on the Decks tab first',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            FilledButton.icon(
              onPressed: () => context.go('/decks'),
              icon: const Icon(Icons.collections_bookmark_rounded),
              label: const Text('Go to Decks'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, List<Deck> decks) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            children: [
              // ── Deck selector ──
              Text(
                'Choose your deck',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: decks.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppTheme.spacingMd),
                  itemBuilder: (_, index) {
                    final deck = decks[index];
                    final isSelected = deck.id == _selectedDeckId;
                    return _DeckSelectionCard(
                      deck: deck,
                      isSelected: isSelected,
                      colorIndex: index,
                      onTap: () =>
                          setState(() => _selectedDeckId = deck.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // ── Game mode ──
              Text(
                'Game mode',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              _buildModeCard(
                context,
                mode: GameMode.translationToWord,
                isSelected: _selectedMode == GameMode.translationToWord,
                onTap: () =>
                    setState(() => _selectedMode = GameMode.translationToWord),
              ),
            ],
          ),
        ),

        // ── Bottom bar ──
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingLg,
              AppTheme.spacingSm,
              AppTheme.spacingLg,
              AppTheme.spacingLg,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _selectedDeckId != null
                    ? () {
                        final deck =
                            decks.firstWhere((d) => d.id == _selectedDeckId);
                        context.push(
                          AppRoutes.gameBattle(deck.id),
                          extra: {'mode': _selectedMode},
                        );
                      }
                    : null,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start Battle!',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ),
      ],
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
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Center(
                  child: Text(
                    '⚔️',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
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
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      mode.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              if (isSelected)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Deck selection card — horizontal, compact
// ─────────────────────────────────────────────────────────
class _DeckSelectionCard extends StatelessWidget {
  final Deck deck;
  final bool isSelected;
  final int colorIndex;
  final VoidCallback onTap;

  const _DeckSelectionCard({
    required this.deck,
    required this.isSelected,
    required this.colorIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColors = AppColors.deckGradient(colorIndex);
    final accentColor = AppColors.deckColor(colorIndex);
    final width = 140.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: AnimatedContainer(
          duration: AppTheme.animFast,
          curve: AppTheme.animCurve,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: isSelected ? accentColor : Colors.transparent,
              width: isSelected ? 2.5 : 0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              AppTheme.radiusMd - (isSelected ? 2.5 : 0),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top row: badge + check ──
                    Row(
                      children: [
                        // Card count badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingSm - 2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.credit_card_rounded,
                                size: 10,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${deck.cardCount}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                      ],
                    ),
                    const Spacer(),
                    // ── Deck name ──
                    Text(
                      deck.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
