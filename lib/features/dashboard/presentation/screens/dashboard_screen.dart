import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/services/router_service.dart';
import '../widgets/health_metric_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/weekly_chart.dart';

/// Main dashboard screen
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final greeting = _getGreeting();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    'User', // TODO: Replace with actual user name
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Show notifications
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push(AppRoutes.settings),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Health Score Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _HealthScoreCard()
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1),
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.add_circle_outline,
                          label: 'Log Vitals',
                          color: AppColors.stepsColor,
                          onTap: () => context.go(AppRoutes.vitals),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.psychology,
                          label: 'Ask AI',
                          color: AppColors.primary,
                          onTap: () => context.go(AppRoutes.aiChat),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.mic,
                          label: 'Journal',
                          color: AppColors.secondary,
                          onTap: () => context.go(AppRoutes.journal),
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Health Metrics Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Today's Vitals",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              delegate: SliverChildListDelegate([
                HealthMetricCard(
                  icon: Icons.directions_walk,
                  label: 'Steps',
                  value: '8,432',
                  unit: 'steps',
                  progress: 0.84,
                  color: AppColors.stepsColor,
                ).animate().fadeIn(delay: 300.ms),
                HealthMetricCard(
                  icon: Icons.bedtime_outlined,
                  label: 'Sleep',
                  value: '7.5',
                  unit: 'hours',
                  progress: 0.94,
                  color: AppColors.sleepColor,
                ).animate().fadeIn(delay: 350.ms),
                HealthMetricCard(
                  icon: Icons.water_drop_outlined,
                  label: 'Water',
                  value: '2.1',
                  unit: 'liters',
                  progress: 0.70,
                  color: AppColors.waterColor,
                ).animate().fadeIn(delay: 400.ms),
                HealthMetricCard(
                  icon: Icons.mood,
                  label: 'Mood',
                  value: '8',
                  unit: '/10',
                  progress: 0.80,
                  color: AppColors.moodHappyColor,
                ).animate().fadeIn(delay: 450.ms),
              ]),
            ),
          ),

          // Weekly Overview Chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const WeeklyChart(),
                ],
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
            ),
          ),

          // Recent AI Insights
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AI Insights',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.aiChat),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InsightCard(
                    icon: Icons.lightbulb_outline,
                    title: 'Great sleep pattern!',
                    description:
                        'You\'ve been getting consistent 7+ hours of sleep. Keep it up for better energy levels.',
                    color: AppColors.sleepColor,
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

/// Health score overview card
class _HealthScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Score',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '85',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 4),
                      child: Text(
                        '/100',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+5 from last week',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: 0.85,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.favorite, color: Colors.white, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// AI insight card
class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _InsightCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
