import 'package:flutter/material.dart';
import 'package:momentum/features/habits/presentation/screens/add_habit_screen.dart';
import 'package:momentum/features/habits/presentation/screens/home_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/greeting_widget.dart';
import '../widgets/habits_glimpse.dart';
import '../widgets/motivation_card.dart';
import '../widgets/statistics_row.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _navigateToHabits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const GreetingWidget(),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surface,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=12'), // Placeholder user image
                    onBackgroundImageError: (_, __) {},
                    child: const Icon(Icons.person, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Motivation
              const MotivationCard(),
              const SizedBox(height: 32),

              // Statistics
              const StatisticsRow(),
              const SizedBox(height: 32),

              // Habits Glimpse
              HabitsGlimpse(
                onViewAll: () => _navigateToHabits(context),
              ),
              
              // Extra spacing at bottom
              const SizedBox(height: 80),
            ],
          ),
        ),
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
