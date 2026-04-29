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
            const SizedBox(height: 8),

            // Question area
            Expanded(
              child: _QuestionArea(state: state),
            ),
            const SizedBox(height: 8),

            // Timer
            if (state.phase == GamePhase.waitingForAnswer)
              _TimerBar(secondsRemaining: state.timerSecondsRemaining),

            // Player hand
            _PlayerHand(
              cards: state.playerHand,
              question: state.currentQuestion,
              phase: state.phase,
              lastAnswerCorrect: state.lastAnswerCorrect,
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
                  Text(
                    'Cards: ${state.totalCards}',
                    style: theme.textTheme.bodySmall,
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
              const Icon(Icons.timer_outlined, size: 16),
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

// ── Question Area ──

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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: question != null
            ? Padding(
                key: ValueKey(question.word + state.turnNumber.toString()),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pick the character for...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            question.translation,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.mode.displayName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer.withAlpha(150),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.phase == GamePhase.showingResult && state.resultMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.resultMessage!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: state.lastAnswerCorrect == true
                                ? Colors.green
                                : Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

// ── Player Hand ──

class _PlayerHand extends StatelessWidget {
  final List<WordCard> cards;
  final WordCard? question;
  final GamePhase phase;
  final bool? lastAnswerCorrect;
  final ValueChanged<WordCard> onCardTap;

  const _PlayerHand({
    required this.cards,
    required this.question,
    required this.phase,
    required this.lastAnswerCorrect,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (cards.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Text('No cards in hand', style: TextStyle(color: Colors.grey)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        height: 110,
        child: Row(
          children: cards.map((card) {
            final isCorrectAnswer = question != null &&
                card.word == question!.word &&
                phase == GamePhase.showingResult;

            Color? bgColor;
            if (phase == GamePhase.showingResult) {
              if (isCorrectAnswer) {
                bgColor = Colors.green.shade100;
              }
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Material(
                  color: bgColor ?? theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: phase == GamePhase.waitingForAnswer
                        ? () => onCardTap(card)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: isCorrectAnswer
                            ? Border.all(color: Colors.green, width: 2)
                            : null,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            card.word,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (card.pinyin != null)
                            Text(
                              card.pinyin!,
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
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
