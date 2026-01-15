import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:momentum/core/theme/app_colors.dart';

class HabitCalendar extends StatelessWidget {
  final Map<String, bool> completionMap;

  const HabitCalendar({super.key, required this.completionMap});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 30)),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppColors.textDisabled,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) => _buildDay(day),
        todayBuilder: (context, day, focusedDay) => _buildDay(day),
      ),
    );
  }

  Widget? _buildDay(DateTime day) {
    final dateKey = day.toIso8601String().split('T')[0];
    final isCompleted = completionMap[dateKey] == true;

    if (isCompleted) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    }
    return null;
  }
}
