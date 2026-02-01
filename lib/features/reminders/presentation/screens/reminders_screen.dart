import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

/// Reminders screen
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final List<_Reminder> _reminders = [
    _Reminder(
      id: '1',
      title: 'Log Morning Vitals',
      description: 'Record weight, mood, and sleep quality',
      time: const TimeOfDay(hour: 8, minute: 0),
      days: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      isActive: true,
      icon: Icons.favorite,
      color: AppColors.heartColor,
    ),
    _Reminder(
      id: '2',
      title: 'Hydration Check',
      description: 'Drink water and log intake',
      time: const TimeOfDay(hour: 12, minute: 0),
      days: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      isActive: true,
      icon: Icons.water_drop,
      color: AppColors.waterColor,
    ),
    _Reminder(
      id: '3',
      title: 'Evening Walk',
      description: 'Take a 30-minute walk',
      time: const TimeOfDay(hour: 18, minute: 30),
      days: ['Mon', 'Wed', 'Fri'],
      isActive: false,
      icon: Icons.directions_walk,
      color: AppColors.stepsColor,
    ),
    _Reminder(
      id: '4',
      title: 'Journal Entry',
      description: 'Reflect on your day',
      time: const TimeOfDay(hour: 21, minute: 0),
      days: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      isActive: true,
      icon: Icons.book,
      color: AppColors.secondary,
    ),
  ];

  void _showAddReminderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddReminderSheet(
        onSave: (reminder) {
          setState(() => _reminders.add(reminder));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: _reminders.isEmpty
          ? _EmptyState(onAdd: _showAddReminderSheet)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return _ReminderCard(
                  reminder: reminder,
                  onToggle: (value) {
                    setState(() {
                      _reminders[index] = reminder.copyWith(isActive: value);
                    });
                  },
                  onDelete: () {
                    setState(() => _reminders.removeAt(index));
                  },
                ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReminderSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
      ),
    );
  }
}

class _Reminder {
  final String id;
  final String title;
  final String description;
  final TimeOfDay time;
  final List<String> days;
  final bool isActive;
  final IconData icon;
  final Color color;

  const _Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.days,
    required this.isActive,
    required this.icon,
    required this.color,
  });

  _Reminder copyWith({bool? isActive}) {
    return _Reminder(
      id: id,
      title: title,
      description: description,
      time: time,
      days: days,
      isActive: isActive ?? this.isActive,
      icon: icon,
      color: color,
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final _Reminder reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const _ReminderCard({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: reminder.isActive
            ? Border.all(color: reminder.color.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: reminder.color.withValues(
                      alpha: reminder.isActive ? 0.1 : 0.05,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    reminder.icon,
                    color: reminder.isActive
                        ? reminder.color
                        : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: reminder.isActive
                              ? null
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reminder.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: reminder.isActive ? 0.6 : 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: reminder.isActive,
                  onChanged: onToggle,
                  activeColor: reminder.color,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 6),
                Text(
                  reminder.time.format(context),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    reminder.days.length == 7
                        ? 'Every day'
                        : reminder.days.join(', '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppColors.error,
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

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
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: AppColors.accent,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Reminders Yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set up reminders to stay on track with your health goals.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAdd,
              child: const Text('Add First Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddReminderSheet extends StatefulWidget {
  final Function(_Reminder) onSave;

  const _AddReminderSheet({required this.onSave});

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final Set<String> _selectedDays = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
              'New Reminder',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Take medication',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add details...',
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Time'),
              trailing: TextButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (time != null) {
                    setState(() => _selectedTime = time);
                  }
                },
                child: Text(_selectedTime.format(context)),
              ),
            ),
            const SizedBox(height: 8),
            Text('Repeat', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map(
                    (day) => FilterChip(
                      label: Text(day),
                      selected: _selectedDays.contains(day),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDays.add(day);
                          } else {
                            _selectedDays.remove(day);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isEmpty) return;
                widget.onSave(
                  _Reminder(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    time: _selectedTime,
                    days: _selectedDays.toList(),
                    isActive: true,
                    icon: Icons.notifications,
                    color: AppColors.primary,
                  ),
                );
              },
              child: const Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
