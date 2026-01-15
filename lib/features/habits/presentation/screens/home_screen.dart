import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/habit_provider.dart';
import 'add_habit_screen.dart';
import '../widgets/habit_card.dart';
import 'habit_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            floating: true,
            centerTitle: false,
            title: const Text(
              'Momentum',
              style: TextStyle(
                color: AppColors.textPrimary, 
                fontWeight: FontWeight.w800,
                fontSize: 28,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: AppColors.textPrimary),
                onPressed: () {
                  // Settings
                },
              ),
            ],
          ),

          // Content
          habits.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_florist_outlined, size: 64, color: AppColors.textDisabled),
                        const SizedBox(height: 16),
                        const Text(
                          'No habits yet.\nStart building momentum today!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final habit = habits[index];
                        return HabitCard(
                          habit: habit, 
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: habit)),
                            );
                          },
                        );
                      },
                      childCount: habits.length,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
