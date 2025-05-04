import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/view/evaluation_screen.dart';
import 'package:ammentor/screen/evaluation/model/mentee_tasks_model.dart';

class TaskTile extends ConsumerWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (task.status != TaskStatus.returned) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskEvaluationScreen(task: task),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Container(
              width: 30.0,
              height: 30.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.grey[800],
              ),
              child: Text(
                '${task.taskNumber}',
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            const SizedBox(width: 12.0),
            Icon(task.icon, color: Colors.white, size: 20.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                task.taskName,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
