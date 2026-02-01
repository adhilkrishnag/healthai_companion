import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';

/// Bottom sheet for inputting vitals
class VitalsInputSheet extends StatefulWidget {
  const VitalsInputSheet({super.key});

  @override
  State<VitalsInputSheet> createState() => _VitalsInputSheetState();
}

class _VitalsInputSheetState extends State<VitalsInputSheet> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _stepsController = TextEditingController();
  final _sleepController = TextEditingController();
  final _waterController = TextEditingController();
  int _moodScore = 5;

  @override
  void dispose() {
    _weightController.dispose();
    _stepsController.dispose();
    _sleepController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  void _saveVitals() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save vitals to Hive
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vitals logged successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
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

                  // Title
                  Text(
                    'Log Your Vitals',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your daily health metrics',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Weight input
                  _VitalInput(
                    controller: _weightController,
                    label: 'Weight',
                    hint: 'Enter weight',
                    suffix: 'kg',
                    icon: Icons.fitness_center,
                    color: AppColors.weightColor,
                    keyboardType: TextInputType.number,
                    validator: Validators.weight,
                  ),
                  const SizedBox(height: 16),

                  // Steps input
                  _VitalInput(
                    controller: _stepsController,
                    label: 'Steps',
                    hint: 'Enter steps',
                    suffix: 'steps',
                    icon: Icons.directions_walk,
                    color: AppColors.stepsColor,
                    keyboardType: TextInputType.number,
                    validator: Validators.steps,
                  ),
                  const SizedBox(height: 16),

                  // Sleep input
                  _VitalInput(
                    controller: _sleepController,
                    label: 'Sleep',
                    hint: 'Enter sleep hours',
                    suffix: 'hours',
                    icon: Icons.bedtime,
                    color: AppColors.sleepColor,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: Validators.sleepHours,
                  ),
                  const SizedBox(height: 16),

                  // Water input
                  _VitalInput(
                    controller: _waterController,
                    label: 'Water Intake',
                    hint: 'Enter water intake',
                    suffix: 'liters',
                    icon: Icons.water_drop,
                    color: AppColors.waterColor,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: Validators.waterIntake,
                  ),
                  const SizedBox(height: 24),

                  // Mood selector
                  Text(
                    'How are you feeling today?',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MoodSelector(
                    value: _moodScore,
                    onChanged: (value) => setState(() => _moodScore = value),
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  ElevatedButton(
                    onPressed: _saveVitals,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('Save Vitals'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VitalInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String suffix;
  final IconData icon;
  final Color color;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _VitalInput({
    required this.controller,
    required this.label,
    required this.hint,
    required this.suffix,
    required this.icon,
    required this.color,
    required this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

class _MoodSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _MoodSelector({required this.value, required this.onChanged});

  static const List<String> _moodEmojis = [
    '😢',
    '😞',
    '😕',
    '😐',
    '🙂',
    '😊',
    '😄',
    '😁',
    '🤩',
    '🥳',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(10, (index) {
        final score = index + 1;
        final isSelected = score == value;
        return GestureDetector(
          onTap: () => onChanged(score),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 40 : 32,
            height: isSelected ? 40 : 32,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _moodEmojis[index],
                style: TextStyle(fontSize: isSelected ? 24 : 18),
              ),
            ),
          ),
        );
      }),
    );
  }
}
