import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:momentum/app.dart';
import 'package:momentum/features/habits/domain/habit.dart';

// Mock Hive for testing if needed, or just skip hive init in widget test context if difficult.
// For basic smoke test, we might need to mock or initialize hive.

void main() {
  setUpAll(() async {
    // Basic Hive binding for tests (in-memory)
    Hive.initFlutter(); 
    // Register adapter if we were actually loading habits, but for smoke test of App widget it might suffice just to have ProviderScope.
    // However, the main App widget loads HomeScreen which watches habitProvider which initializes HabitNotifier which opens 'habits' box.
    // This makes testing tricky without mocking.
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // To properly test, we should override the repository provider to not use Hive.
    
    await tester.pumpWidget(
      const ProviderScope(
        child: MomentumApp(),
      ),
    );

    // Verify that we see the title.
    expect(find.text('Momentum'), findsOneWidget);
    expect(find.text('No habits yet.\nStart building momentum today!'), findsOneWidget);
  });
}
