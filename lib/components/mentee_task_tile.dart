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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
