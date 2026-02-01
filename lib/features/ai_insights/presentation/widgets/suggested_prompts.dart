import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

/// Suggested prompts widget for AI chat
class SuggestedPrompts extends StatelessWidget {
  final Function(String) onPromptTap;

  const SuggestedPrompts({super.key, required this.onPromptTap});

  static const List<_PromptItem> _prompts = [
    _PromptItem(
      icon: Icons.bedtime,
      text: 'How can I improve my sleep quality?',
      color: AppColors.sleepColor,
    ),
    _PromptItem(
      icon: Icons.fitness_center,
      text: 'Create a workout plan for me',
      color: AppColors.stepsColor,
    ),
    _PromptItem(
      icon: Icons.restaurant,
      text: 'What foods should I eat for energy?',
      color: AppColors.accent,
    ),
    _PromptItem(
      icon: Icons.self_improvement,
      text: 'Tips for reducing stress',
      color: AppColors.secondary,
    ),
    _PromptItem(
      icon: Icons.water_drop,
      text: 'How much water should I drink?',
      color: AppColors.waterColor,
    ),
    _PromptItem(
      icon: Icons.favorite,
      text: 'Analyze my health trends',
      color: AppColors.heartColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _prompts.asMap().entries.map((entry) {
        final index = entry.key;
        final prompt = entry.value;
        return _PromptCard(
              prompt: prompt,
              onTap: () => onPromptTap(prompt.text),
            )
            .animate()
            .fadeIn(delay: Duration(milliseconds: 100 * index))
            .slideX(begin: -0.1);
      }).toList(),
    );
  }
}

class _PromptItem {
  final IconData icon;
  final String text;
  final Color color;

  const _PromptItem({
    required this.icon,
    required this.text,
    required this.color,
  });
}

class _PromptCard extends StatelessWidget {
  final _PromptItem prompt;
  final VoidCallback onTap;

  const _PromptCard({required this.prompt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: prompt.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(prompt.icon, color: prompt.color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    prompt.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: prompt.color, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
