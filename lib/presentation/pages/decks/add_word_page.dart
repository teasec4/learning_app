import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:learning_app/core/app_theme.dart';
import 'package:learning_app/presentation/providers/word_card_provider.dart';
import 'package:learning_app/domain/entities/word_card.dart';

class AddWordPage extends StatefulWidget {
  final int deckId;
  final WordCard? editCard;

  const AddWordPage({super.key, this.deckId = 0, this.editCard});

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _pinyinController = TextEditingController();
  final _translationController = TextEditingController();
  final _contextController = TextEditingController();
  final _notesController = TextEditingController();
  final _sourceController = TextEditingController();
  bool _saving = false;
  bool get _isEditing => widget.editCard != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final c = widget.editCard!;
      _wordController.text = c.word;
      _pinyinController.text = c.pinyin ?? '';
      _translationController.text = c.translation;
      _contextController.text = c.contextSentence ?? '';
      _notesController.text = c.notes ?? '';
      _sourceController.text = c.source ?? '';
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _pinyinController.dispose();
    _translationController.dispose();
    _contextController.dispose();
    _notesController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit card" : "New word"),
        actions: [
          TextButton(
            onPressed: _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isEditing ? "Update" : "Save"),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          children: [
            // ── Required fields section ──
            // Word — prominent field
            Text(
              "Word",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextFormField(
              controller: _wordController,
              style: AppTheme.chineseStyle(
                size: 22,
                weight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: "学习",
                hintStyle: TextStyle(fontSize: 22),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? "Required" : null,
              autofocus: !_isEditing,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Pinyin
            Text(
              "Pinyin",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextFormField(
              controller: _pinyinController,
              style: AppTheme.pinyinStyle(),
              decoration: const InputDecoration(
                hintText: "xuéxí",
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Translation
            Text(
              "Translation",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextFormField(
              controller: _translationController,
              decoration: const InputDecoration(
                hintText: "to study, learn",
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? "Required" : null,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Context sentence
            Text(
              "Sentence context",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextFormField(
              controller: _contextController,
              style: AppTheme.chineseStyle(size: 16),
              decoration: const InputDecoration(
                hintText: "我在学习中文。",
                hintStyle: TextStyle(fontSize: 16),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // ── Divider + Optional section ──
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                  ),
                  child: Text(
                    "Optional",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Notes
            Text(
              "Notes",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: "E.g. often confused with ...",
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Source
            Text(
              "Source",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextFormField(
              controller: _sourceController,
              decoration: const InputDecoration(
                hintText: "Textbook, Weibo, drama ...",
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final provider = context.read<WordCardProvider>();
      final word = _wordController.text.trim();
      final pinyin = _pinyinController.text.trim().isEmpty
          ? null
          : _pinyinController.text.trim();
      final translation = _translationController.text.trim();
      final contextSentence = _contextController.text.trim().isEmpty
          ? null
          : _contextController.text.trim();
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();
      final source = _sourceController.text.trim().isEmpty
          ? null
          : _sourceController.text.trim();

      if (_isEditing) {
        final c = widget.editCard!;
        await provider.updateCard(
          WordCard(
            id: c.id,
            deckId: c.deckId,
            word: word,
            pinyin: pinyin,
            translation: translation,
            contextSentence: contextSentence,
            notes: notes,
            source: source,
            createdAt: c.createdAt,
          ),
        );
      } else {
        await provider.addCard(
          deckId: widget.deckId,
          word: word,
          pinyin: pinyin,
          translation: translation,
          contextSentence: contextSentence,
          notes: notes,
          source: source,
        );
      }

      if (mounted) {
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }
}
