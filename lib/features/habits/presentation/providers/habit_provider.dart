import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/habit_repository.dart';
import '../../domain/habit.dart';

final habitRepositoryProvider = Provider((ref) => HabitRepository());

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitNotifier(repository);
});

class HabitNotifier extends StateNotifier<List<Habit>> {
  final HabitRepository _repository;

  HabitNotifier(this._repository) : super([]) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    final habits = await _repository.getAllHabits();
    state = habits;
  }

  Future<void> addHabit(String title) async {
    final newHabit = Habit.create(title: title);
    await _repository.addHabit(newHabit);
    state = [...state, newHabit];
  }

  Future<void> deleteHabit(String id) async {
    await _repository.deleteHabit(id);
    state = state.where((h) => h.id != id).toList();
  }

  Future<void> toggleCompletion(String id, DateTime date) async {
    final habitIndex = state.indexWhere((h) => h.id == id);
    if (habitIndex == -1) return;

    final habit = state[habitIndex];
    final dateKey = date.toIso8601String().split('T')[0];
    final isCompleted = habit.completionMap[dateKey] ?? false;
    final newMap = Map<String, bool>.from(habit.completionMap);
    if (!isCompleted) {
      newMap[dateKey] = true;
    } else {
      newMap.remove(dateKey);
    }
    int currentStreak = _calculateStreak(newMap);
    final updatedHabit = Habit(
      id: habit.id,
      title: habit.title,
      createdAt: habit.createdAt,
      completionMap: newMap,
      currentStreak: currentStreak,
      bestStreak: currentStreak > habit.bestStreak ? currentStreak : habit.bestStreak,
    );

    await _repository.updateHabit(updatedHabit);
    final newState = [...state];
    newState[habitIndex] = updatedHabit;
    state = newState;
  }

  int _calculateStreak(Map<String, bool> completionMap) {
    if (completionMap.isEmpty) return 0;
    
    int streak = 0;
    DateTime checkDate = DateTime.now();
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    // 1. Check Today
    String dateKey = checkDate.toIso8601String().split('T')[0];
    if (completionMap[dateKey] == true) {
      streak++;
    }
    
    // 2. Loop backwards indefinitely until a break is found
    while (true) {
      checkDate = checkDate.subtract(const Duration(days: 1));
      dateKey = checkDate.toIso8601String().split('T')[0];
      
      if (completionMap[dateKey] == true) {
        streak++;
      } else {
        // If today is NOT done, we verify if yesterday was done.
        // If yesterday was broken too, then streak is 0.
        // The loop handles this: if today=false, streak=0. We enter loop.
        // We check yesterday. If yesterday=false, streak stays 0 and we break. Correct.
        // If yesterday=true, streak becomes 1. Correct.
        break;
      }
    }
    
    return streak;
  }
}
