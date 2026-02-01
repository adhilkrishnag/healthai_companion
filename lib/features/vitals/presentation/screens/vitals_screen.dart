import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/vitals_input_sheet.dart';
import '../widgets/vitals_history_list.dart';

/// Vitals tracking screen
class VitalsScreen extends ConsumerStatefulWidget {
  const VitalsScreen({super.key});

  @override
  ConsumerState<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends ConsumerState<VitalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddVitalsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VitalsInputSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vitals'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Weight'),
            Tab(text: 'Steps'),
            Tab(text: 'Sleep'),
            Tab(text: 'Mood'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _VitalsTab(
            title: 'Weight',
            icon: Icons.fitness_center,
            color: AppColors.weightColor,
            currentValue: '72.5',
            unit: 'kg',
            trend: '+0.5',
            trendUp: true,
          ),
          _VitalsTab(
            title: 'Steps',
            icon: Icons.directions_walk,
            color: AppColors.stepsColor,
            currentValue: '8,432',
            unit: 'steps',
            trend: '+1,234',
            trendUp: true,
          ),
          _VitalsTab(
            title: 'Sleep',
            icon: Icons.bedtime,
            color: AppColors.sleepColor,
            currentValue: '7.5',
            unit: 'hours',
            trend: '+0.5',
            trendUp: true,
          ),
          _VitalsTab(
            title: 'Mood',
            icon: Icons.mood,
            color: AppColors.moodHappyColor,
            currentValue: '8',
            unit: '/10',
            trend: '+1',
            trendUp: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddVitalsSheet,
        icon: const Icon(Icons.add),
        label: const Text('Log Vitals'),
      ),
    );
  }
}

class _VitalsTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String currentValue;
  final String unit;
  final String trend;
  final bool trendUp;

  const _VitalsTab({
    required this.title,
    required this.icon,
    required this.color,
    required this.currentValue,
    required this.unit,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // Current value card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _CurrentValueCard(
              title: title,
              icon: icon,
              color: color,
              value: currentValue,
              unit: unit,
              trend: trend,
              trendUp: trendUp,
            ).animate().fadeIn(duration: 400.ms),
          ),
        ),

        // Chart
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _VitalsChart(
              color: color,
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ),
        ),

        // History header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'History',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('See all')),
              ],
            ),
          ),
        ),

        // History list
        VitalsHistoryList(color: color),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _CurrentValueCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String value;
  final String unit;
  final String trend;
  final bool trendUp;

  const _CurrentValueCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.value,
    required this.unit,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
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
                Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Current $title',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        unit,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp ? Icons.trending_up : Icons.trending_down,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$trend from last week',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }
}

class _VitalsChart extends StatelessWidget {
  final Color color;

  const _VitalsChart({required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.dividerColor.withValues(alpha: 0.3),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  if (value.toInt() < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        days[value.toInt()],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 70),
                FlSpot(1, 72),
                FlSpot(2, 71),
                FlSpot(3, 73),
                FlSpot(4, 72),
                FlSpot(5, 74),
                FlSpot(6, 72.5),
              ],
              isCurved: true,
              color: color,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: color,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
