import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final Map<String, bool> completionMap; // Key: "yyyy-MM-dd", Value: true

  @HiveField(4)
  final int currentStreak;

  @HiveField(5)
  final int bestStreak;

  Habit({
    required this.id,
    required this.title,
    required this.createdAt,
    Map<String, bool>? completionMap,
    this.currentStreak = 0,
    this.bestStreak = 0,
  }) : completionMap = completionMap ?? {};

  factory Habit.create({required String title}) {
    return Habit(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
    );
  }

  bool isCompletedToday() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return completionMap[today] == true;
  }
  
  bool isCompletedOn(DateTime date) {
    final dateKey = date.toIso8601String().split('T')[0];
    return completionMap[dateKey] == true;
  }
}
