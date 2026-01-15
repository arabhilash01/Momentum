import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/habit.dart';
import '../providers/habit_provider.dart';


class HabitCard extends ConsumerWidget {
  final Habit habit;
  final VoidCallback? onTap;

  const HabitCard({super.key, required this.habit, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompletedToday = habit.isCompletedToday();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Checkbox Area
              GestureDetector(
                onTap: () {
                  ref.read(habitProvider.notifier).toggleCompletion(habit.id, DateTime.now());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: isCompletedToday ? AppColors.success : AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                    border: isCompletedToday
                        ? null
                        : Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: isCompletedToday
                        ? const Icon(Icons.check, color: Colors.white, size: 28)
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Title & Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        decoration: isCompletedToday ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.textDisabled,
                        color: isCompletedToday ? AppColors.textDisabled : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${habit.currentStreak} day streak',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow to indicate details
              const Icon(Icons.chevron_right, size: 24, color: AppColors.textDisabled),
            ],
          ),
        ),
      ),
    );
  }
}
