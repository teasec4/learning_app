import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/presentation/providers/word_card_provider.dart';
import 'package:learning_app/presentation/pages/decks/add_word_page.dart';

class DeckDetailPage extends StatefulWidget {
  final int deckId;

  const DeckDetailPage({
    super.key,
    required this.deckId,
  });

  @override
  State<DeckDetailPage> createState() => _DeckDetailPageState();
}

class _DeckDetailPageState extends State<DeckDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WordCardProvider>().loadCards(widget.deckId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deckProvider = context.watch<DeckProvider>();
    final deck = deckProvider.decks.where((d) => d.id == widget.deckId).firstOrNull;
    final deckName = deck?.name ?? "Колода";

    return Scaffold(
      appBar: AppBar(
        title: Text(deckName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddWordPage(deckId: widget.deckId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<WordCardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final cards = provider.cards;
          if (cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "В этой колоде пока нет карточек",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddWordPage(deckId: widget.deckId),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Добавить карточку"),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Dismissible(
                key: ValueKey(card.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<WordCardProvider>().deleteCard(card.id, widget.deckId);
                },
                child: ListTile(
                  title: Text(
                    card.word,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans SC',
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "${card.pinyin}\n${card.translation}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddWordPage(deckId: widget.deckId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
