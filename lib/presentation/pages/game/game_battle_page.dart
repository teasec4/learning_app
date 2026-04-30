import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning_app/domain/entities/word_card.dart';
import 'package:learning_app/domain/entities/deck.dart';
import 'package:learning_app/domain/entities/game_mode.dart';
import 'package:learning_app/domain/entities/game_state.dart';
import 'package:learning_app/presentation/view_models/game_view_model.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/route/router.dart';
import 'package:go_router/go_router.dart';

class GameBattlePage extends StatefulWidget {
  final int deckId;
  final GameMode mode;

  const GameBattlePage({
    super.key,
    required this.deckId,
    required this.mode,
  });

  @override
  State<GameBattlePage> createState() => _GameBattlePageState();
}

class _GameBattlePageState extends State<GameBattlePage> {
  @override
  Widget build(BuildContext context) {
    final deckProvider = context.watch<DeckProvider>();
    final deck = deckProvider.decks.cast<Deck?>().firstWhere(
      (d) => d?.id == widget.deckId,
      orElse: () => null,
    );

    if (deck == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Battle')),
        body: const Center(child: Text('Deck not found')),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => GameViewModel()..startGame(deck, widget.mode),
      child: _BattleScreen(deck: deck),
    );
  }
}

class _BattleScreen extends StatelessWidget {
  final Deck deck;

  const _BattleScreen({required this.deck});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    final state = vm.state;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showQuitDialog(context, vm),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // AI HP bar
            _HpBar(
              label: 'AI',
              hp: state.aiHp,
              maxHp: 10,
              color: Colors.red,
              inverted: false,
            ),
            const SizedBox(height: 4),

            // Enemy hand (face-down cards)
            _EnemyHand(enemyHandSize: state.enemyHandSize),
            const SizedBox(height: 4),

            // Question area
            Expanded(
              child: _QuestionArea(state: state),
            ),
            const SizedBox(height: 4),

            // Timer
            if (state.phase == GamePhase.playerTurn)
              _TimerBar(secondsRemaining: state.timerSecondsRemaining),

            // Player hand
            _PlayerHand(
              cards: state.playerHand,
              phase: state.phase,
              onCardTap: (card) => vm.selectCard(card),
            ),

            // Player HP bar
            _HpBar(
              label: 'You',
              hp: state.playerHp,
              maxHp: 10,
              color: Colors.green,
              inverted: true,
            ),

            // Bottom info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: ${state.score}',
                    style: theme.textTheme.bodySmall,
                  ),
                  // Deck stack indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.style,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${state.remainingCards.length}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Game over overlay
      bottomSheet: state.phase == GamePhase.gameOver
          ? _GameOverSheet(
              state: state,
              onPlayAgain: () => vm.restart(),
              onBackToLobby: () => context.go(AppRoutes.gameLobby),
            )
          : null,
    );
  }

  void _showQuitDialog(BuildContext context, GameViewModel vm) {
    if (vm.state.phase == GamePhase.gameOver) {
      context.go(AppRoutes.gameLobby);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quit battle?'),
        content: const Text('Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go(AppRoutes.gameLobby);
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}

// ── HP Bar ──

class _HpBar extends StatelessWidget {
  final String label;
  final int hp;
  final int maxHp;
  final Color color;
  final bool inverted;

  const _HpBar({
    required this.label,
    required this.hp,
    required this.maxHp,
    required this.color,
    required this.inverted,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = hp / maxHp;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                inverted ? Icons.favorite : Icons.favorite_border,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(width: 8),
              Text('$hp / $maxHp', style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: color.withAlpha(40),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Timer ──

class _TimerBar extends StatelessWidget {
  final int secondsRemaining;

  const _TimerBar({required this.secondsRemaining});

  @override
  Widget build(BuildContext context) {
    final fraction = secondsRemaining / 10;
    final isUrgent = secondsRemaining <= 3;
    final color = isUrgent ? Colors.orange : Colors.blue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUrgent ? Icons.timer_off_outlined : Icons.timer_outlined,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                '${secondsRemaining}s',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: color.withAlpha(30),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Enemy Hand (face-down cards) ──

class _EnemyHand extends StatelessWidget {
  final int enemyHandSize;

  const _EnemyHand({required this.enemyHandSize});

  @override
  Widget build(BuildContext context) {
    final totalWidth = enemyHandSize * 32.0 + 12.0; // 44 - 12 overlap per card + base

    return SizedBox(
      height: 56,
      width: totalWidth,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(enemyHandSize, (index) {
          final centerIndex = (enemyHandSize - 1) / 2.0;
          final offsetX = (index - centerIndex) * 32.0;
          return Positioned(
            left: (totalWidth / 2) + offsetX - 22,
            child: _CardBack(
              index: index,
              total: enemyHandSize,
            ),
          );
        }),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final int index;
  final int total;

  const _CardBack({required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Slight stagger for a fan/spread effect
    final rotation = (index - (total - 1) / 2) * 0.04;
    final yOffset = (index - (total - 1) / 2).abs() * 2.0;

    return Transform.translate(
      offset: Offset(0, yOffset),
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: 44,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.white.withAlpha(30) : Colors.black.withAlpha(20),
              width: 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      Colors.grey.shade800,
                      Colors.grey.shade900,
                    ]
                  : [
                      Colors.grey.shade400,
                      Colors.grey.shade600,
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.help_outline,
              size: 20,
              color: isDark ? Colors.white.withAlpha(60) : Colors.white.withAlpha(120),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Question Area (big card) ──

class _QuestionArea extends StatelessWidget {
  final GameState state;

  const _QuestionArea({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = state.currentQuestion;

    if (state.phase == GamePhase.gameOver) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Phase indicator ──
          if (state.phase == GamePhase.aiTurn)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "AI's turn...",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          if (state.phase == GamePhase.playerTurn)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Your turn! Pick the matching card.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),

          // ── Question card with animation ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: question != null
                ? Padding(
                    key: ValueKey(question.word + state.turnNumber.toString()),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Result message
                        if (state.phase == GamePhase.resultShown && state.resultMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                state.resultMessage!,
                                key: ValueKey(state.resultMessage),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                        // Enemy question card (same style as player cards but red)
                        Container(
                          constraints: const BoxConstraints(maxWidth: 260),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (state.phase == GamePhase.resultShown
                                        ? Colors.red.shade300
                                        : Colors.red.shade800)
                                    .withAlpha(40),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: Colors.black.withAlpha(50),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                color: state.phase == GamePhase.resultShown
                                    ? Colors.red.shade300
                                    : Colors.red.shade700,
                                  width: state.phase == GamePhase.resultShown ? 2.0 : 1.0,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.red.shade800,
                                    Colors.red.shade900,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // ── Top accent bar ──
                                  Container(
                                    height: 28,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red.shade700.withAlpha(180),
                                          Colors.red.shade800.withAlpha(100),
                                        ],
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withAlpha(40),
                                            border: Border.all(
                                              color: Colors.white.withAlpha(80),
                                              width: 1,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '⚔',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white.withAlpha(180),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'ENEMY',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white.withAlpha(120),
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ── Card body ──
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Mode label
                                        Text(
                                          state.mode.displayName,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white.withAlpha(100),
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        // The question (English translation)
                                        Text(
                                          question.translation,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),

                                        // Bottom accent line
                                        const SizedBox(height: 8),
                                        Container(
                                          height: 2,
                                          width: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(40),
                                            borderRadius: BorderRadius.circular(1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

// ── Player Hand ──

class _PlayerHand extends StatelessWidget {
  final List<WordCard> cards;
  final GamePhase phase;
  final ValueChanged<WordCard> onCardTap;

  const _PlayerHand({
    required this.cards,
    required this.phase,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Text('No cards in hand', style: TextStyle(color: Colors.grey)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        height: 150,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final interCard = 8.0; // gap between cards
            final cardWidth = ((constraints.maxWidth - interCard * (cards.length - 1)) / cards.length)
                .clamp(60.0, 100.0);

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: cards.map((card) {
                final index = cards.indexOf(card);
                return SizedBox(
                  width: cardWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _GameCardWidget(
                      card: card,
                      index: index,
                      isTappable: phase == GamePhase.playerTurn,
                      onTap: () => onCardTap(card),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

// ── Individual Game Card (Hearthstone-style) ──

class _GameCardWidget extends StatefulWidget {
  final WordCard card;
  final int index;
  final bool isTappable;
  final VoidCallback onTap;

  const _GameCardWidget({
    required this.card,
    required this.index,
    required this.isTappable,
    required this.onTap,
  });

  @override
  State<_GameCardWidget> createState() => _GameCardWidgetState();
}

class _GameCardWidgetState extends State<_GameCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _scaleController.forward();
  void _onTapUp(_) => _scaleController.reverse();
  void _onTapCancel() => _scaleController.reverse();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: widget.isTappable ? _onTapDown : null,
        onTapUp: widget.isTappable ? _onTapUp : null,
        onTapCancel: widget.isTappable ? _onTapCancel : null,
        onTap: widget.isTappable ? widget.onTap : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(widget.isTappable ? 50 : 20),
                blurRadius: widget.isTappable ? 12 : 4,
                offset: Offset(0, widget.isTappable ? 4 : 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                  width: 1.0,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _cardGradient(theme),
                ),
              ),
              child: Column(
                children: [
                  // ── Top accent bar ──
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withAlpha(120),
                          theme.colorScheme.primary.withAlpha(60),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(60),
                            border: Border.all(
                              color: Colors.white.withAlpha(120),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${widget.index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Card body ──
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Chinese character
                          Text(
                            widget.card.word,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),

                          // Bottom accent line
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            height: 2,
                            width: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(60),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),

                          // Pinyin
                          if (widget.card.pinyin != null)
                            Text(
                              widget.card.pinyin!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withAlpha(170),
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _cardGradient(ThemeData theme) {
    return [
      theme.colorScheme.surfaceContainerHigh,
      theme.colorScheme.surfaceContainerHighest,
    ];
  }
}

// ── Game Over Sheet ──

class _GameOverSheet extends StatelessWidget {
  final GameState state;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToLobby;

  const _GameOverSheet({
    required this.state,
    required this.onPlayAgain,
    required this.onBackToLobby,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final playerWon = state.resultMessage?.contains('Win') ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            playerWon ? 'Victory!' : 'Defeat',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: playerWon ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatBadge(label: 'Score', value: '${state.score}'),
              _StatBadge(
                label: 'Accuracy',
                value: state.totalCards > 0
                    ? '${(state.correctCount / state.totalCards * 100).round()}%'
                    : '0%',
              ),
              _StatBadge(label: 'Turns', value: '${state.turnNumber}'),
              _StatBadge(
                label: 'Correct',
                value: '${state.correctCount}/${state.totalCards}',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBackToLobby,
                  child: const Text('Back to Lobby'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onPlayAgain,
                  child: const Text('Play Again'),
                ),
              ),
            ],
          ),
          // Bottom safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;

  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
