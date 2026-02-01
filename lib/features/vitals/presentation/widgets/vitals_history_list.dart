import 'package:flutter/material.dart';

/// Vitals history list widget using Slivers
class VitalsHistoryList extends StatelessWidget {
  final Color color;

  const VitalsHistoryList({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample data
    final historyItems = [
      _HistoryItem(date: 'Today', value: '72.5 kg', time: '9:30 AM'),
      _HistoryItem(date: 'Yesterday', value: '72.3 kg', time: '9:15 AM'),
      _HistoryItem(date: 'Jan 30', value: '72.0 kg', time: '10:00 AM'),
      _HistoryItem(date: 'Jan 29', value: '72.2 kg', time: '9:45 AM'),
      _HistoryItem(date: 'Jan 28', value: '71.8 kg', time: '9:30 AM'),
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = historyItems[index];
        return _HistoryListTile(
          item: item,
          color: color,
          isLast: index == historyItems.length - 1,
        );
      }, childCount: historyItems.length),
    );
  }
}

class _HistoryItem {
  final String date;
  final String value;
  final String time;

  const _HistoryItem({
    required this.date,
    required this.value,
    required this.time,
  });
}

class _HistoryListTile extends StatelessWidget {
  final _HistoryItem item;
  final Color color;
  final bool isLast;

  const _HistoryListTile({
    required this.item,
    required this.color,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: isLast ? 0 : 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.timeline, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.date,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
