import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/view/evaluation_screen.dart';
import 'package:ammentor/screen/evaluation/view/evaluation_view_screen.dart';
import 'package:ammentor/screen/evaluation/model/mentee_tasks_model.dart';

class TaskTile extends ConsumerWidget {
  final Task task;
  final VoidCallback? onTaskEvaluated;
  final String? menteeEmail; // <-- Add this

  const TaskTile({super.key, required this.task, this.onTaskEvaluated, this.menteeEmail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () async {
        if (task.status == TaskStatus.returned) {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskEvaluationViewScreen(
                task: task,
                menteeEmail: menteeEmail ?? "",
                onTaskEvaluated: onTaskEvaluated,
              ),
            ),
          );
          if (result == true && onTaskEvaluated != null) {
            onTaskEvaluated!();
          }
        } else {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskEvaluationScreen(task: task, onEvaluated: onTaskEvaluated),
            ),
          );
          if (result == true && onTaskEvaluated != null) {
            onTaskEvaluated!();
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.1,
              height: screenHeight * 0.03,
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
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                task.taskName,
                style:  AppTextStyles.caption(context).copyWith(
                  color: AppColors.white,
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
