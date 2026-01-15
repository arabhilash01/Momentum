import 'package:hive_flutter/hive_flutter.dart';
import '../domain/habit.dart';

class HabitRepository {
  static const String boxName = 'habits';

  Future<Box<Habit>> get _box async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Habit>(boxName);
    }
    return await Hive.openBox<Habit>(boxName);
  }

  Future<void> addHabit(Habit habit) async {
    final box = await _box;
    await box.put(habit.id, habit);
  }

  Future<void> updateHabit(Habit habit) async {
    final box = await _box;
    await box.put(habit.id, habit);
  }

  Future<void> deleteHabit(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  Future<List<Habit>> getAllHabits() async {
    final box = await _box;
    return box.values.toList();
  }
}
