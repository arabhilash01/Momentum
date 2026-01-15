import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final title = _controller.text.trim();
    if (title.isNotEmpty) {
      ref.read(habitProvider.notifier).addHabit(title);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomTextField(
              controller: _controller,
              hintText: 'What habit do you want to build?',
              autofocus: true,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Create Habit',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
