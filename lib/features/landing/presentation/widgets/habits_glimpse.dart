import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../habits/domain/habit.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../../../habits/presentation/widgets/habit_card.dart';
import '../../../habits/presentation/screens/habit_detail_screen.dart';

class HabitsGlimpse extends ConsumerWidget {
  final VoidCallback onViewAll;

  const HabitsGlimpse({
    super.key,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allHabits = ref.watch(habitProvider);
    // Show only incomplete habits first, or just the first few
    final displayHabits = allHabits.take(3).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ongoing Habits',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (displayHabits.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text(
                'No active habits. Start one today!',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ...displayHabits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HabitCard(
                  habit: habit, 
                  onTap: () {
                     Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: habit)),
                    );
                  },
                ),
              )),
      ],
    );
  }
}
