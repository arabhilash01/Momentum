import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_calendar.dart';

class HabitDetailScreen extends ConsumerWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch provider to get updates if streak changes while on this screen
    final habits = ref.watch(habitProvider);
    final currentHabit = habits.firstWhere(
      (h) => h.id == habit.id, 
      orElse: () => habit, // Fallback if deleted (though we should pop)
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {
               ref.read(habitProvider.notifier).deleteHabit(currentHabit.id);
               Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              currentHabit.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 32),
            
            // Stats Row
            Row(
              children: [
                _buildStatCard('Streak', '${currentHabit.currentStreak} days', Icons.local_fire_department),
                 const SizedBox(width: 16),
                _buildStatCard('Best', '${currentHabit.bestStreak} days', Icons.emoji_events),
              ],
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'History',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: HabitCalendar(completionMap: currentHabit.completionMap),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Icon(icon, size: 28, color: AppColors.primary),
             const SizedBox(height: 12),
             Text(
               value,
               style: const TextStyle(
                 fontSize: 24,
                 fontWeight: FontWeight.w800,
                 color: AppColors.textPrimary,
               ),
             ),
             Text(
               label,
               style: const TextStyle(
                 fontSize: 14,
                 color: AppColors.textSecondary,
                 fontWeight: FontWeight.w500,
               ),
             ),
          ],
        ),
      ),
    );
  }
}
