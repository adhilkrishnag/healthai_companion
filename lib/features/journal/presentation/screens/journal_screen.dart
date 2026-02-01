import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../core/theme/app_colors.dart';
import '../widgets/journal_entry_card.dart';

/// Journal screen with voice input
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _transcribedText = '';
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech error: ${error.errorMsg}')),
        );
      },
    );
    setState(() {});
  }

  void _toggleListening() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      if (_transcribedText.isNotEmpty) {
        _showSaveDialog();
      }
    } else {
      setState(() {
        _isListening = true;
        _transcribedText = '';
      });
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _transcribedText = result.recognizedWords;
          });
        },
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
      );
    }
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Journal Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your recorded note:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_transcribedText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save to Hive and get AI summary
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Journal entry saved!')),
              );
              setState(() => _transcribedText = '');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showNewEntrySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NewJournalEntrySheet(
        onSave: (text) {
          // TODO: Save to Hive
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample journal entries
    final entries = [
      _JournalEntry(
        id: '1',
        date: DateTime.now(),
        content:
            'Had a great workout this morning. Feeling energized and motivated. Sleep was good last night, about 7.5 hours.',
        summary: 'Positive morning with good exercise and sleep quality.',
        mood: 8,
      ),
      _JournalEntry(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 1)),
        content:
            'Feeling a bit tired today. Didn\'t sleep well due to stress about work. Need to practice some relaxation techniques.',
        summary: 'Fatigue from poor sleep and work stress.',
        mood: 5,
      ),
      _JournalEntry(
        id: '3',
        date: DateTime.now().subtract(const Duration(days: 2)),
        content:
            'Wonderful day! Went for a long walk in the park and met some friends. Ate healthy meals throughout the day.',
        summary: 'Active social day with healthy eating habits.',
        mood: 9,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: entries.isEmpty
          ? _EmptyState(onGetStarted: _showNewEntrySheet)
          : CustomScrollView(
              slivers: [
                // Voice recording card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _VoiceRecordingCard(
                      isListening: _isListening,
                      transcribedText: _transcribedText,
                      onToggle: _toggleListening,
                      speechAvailable: _speechAvailable,
                    ).animate().fadeIn(duration: 400.ms),
                  ),
                ),

                // Recent entries header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Recent Entries',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Journal entries list
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return JournalEntryCard(entry: entries[index])
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 100 * index));
                    }, childCount: entries.length),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewEntrySheet,
        icon: const Icon(Icons.edit),
        label: const Text('New Entry'),
      ),
    );
  }
}

class _JournalEntry {
  final String id;
  final DateTime date;
  final String content;
  final String summary;
  final int mood;

  const _JournalEntry({
    required this.id,
    required this.date,
    required this.content,
    required this.summary,
    required this.mood,
  });
}

class _VoiceRecordingCard extends StatelessWidget {
  final bool isListening;
  final String transcribedText;
  final VoidCallback onToggle;
  final bool speechAvailable;

  const _VoiceRecordingCard({
    required this.isListening,
    required this.transcribedText,
    required this.onToggle,
    required this.speechAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.mic, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice Journal',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      speechAvailable
                          ? 'Tap to start recording your thoughts'
                          : 'Speech recognition not available',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isListening
                        ? Colors.red
                        : Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          if (isListening || transcribedText.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isListening)
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Listening...',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  if (transcribedText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      transcribedText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onGetStarted;

  const _EmptyState({required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.book,
                color: AppColors.secondary,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Start Your Health Journal',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Record your thoughts, symptoms, and wellness journey. Use voice or text to capture moments.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onGetStarted,
              child: const Text('Create First Entry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewJournalEntrySheet extends StatefulWidget {
  final Function(String) onSave;

  const _NewJournalEntrySheet({required this.onSave});

  @override
  State<_NewJournalEntrySheet> createState() => _NewJournalEntrySheetState();
}

class _NewJournalEntrySheetState extends State<_NewJournalEntrySheet> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'New Journal Entry',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: 6,
              autofocus: true,
              decoration: const InputDecoration(
                hintText:
                    'Write about your health, feelings, or experiences...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.trim().isNotEmpty) {
                  widget.onSave(_textController.text);
                }
              },
              child: const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
