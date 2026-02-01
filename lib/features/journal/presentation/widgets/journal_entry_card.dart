import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';

/// Journal entry card widget
class JournalEntryCard extends StatelessWidget {
  final dynamic entry;

  const JournalEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _MoodIndicator(mood: entry.mood),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(entry.date),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(entry.date),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 12),

          // AI Summary
          if (entry.summary != null && entry.summary.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.summary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Content preview
          Text(
            entry.content,
            style: theme.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) return 'Today';
    if (entryDate == today.subtract(const Duration(days: 1)))
      return 'Yesterday';
    return DateFormat('MMMM d').format(date);
  }
}

class _MoodIndicator extends StatelessWidget {
  final int mood;

  const _MoodIndicator({required this.mood});

  @override
  Widget build(BuildContext context) {
    final color = _getMoodColor(mood);
    final emoji = _getMoodEmoji(mood);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
    );
  }

  Color _getMoodColor(int mood) {
    if (mood >= 7) return AppColors.moodHappyColor;
    if (mood >= 4) return AppColors.moodNeutralColor;
    return AppColors.moodSadColor;
  }

  String _getMoodEmoji(int mood) {
    if (mood >= 9) return '🥳';
    if (mood >= 7) return '😊';
    if (mood >= 5) return '🙂';
    if (mood >= 3) return '😕';
    return '😢';
  }
}
