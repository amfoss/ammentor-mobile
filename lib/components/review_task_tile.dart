import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/review/model/review_model.dart';
import 'package:ammentor/screen/review/view/submission_screen.dart';

class ReviewTaskTile extends ConsumerWidget {
  final ReviewTask task;

  const ReviewTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        if (task.status != TaskStatus.reviewed) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskSubmissionScreen(task: task),
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
              height: screenHeight*0.03,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.grey[800],
              ),
              child: Text(
                '${task.taskNumber}',
                style:  AppTextStyles.caption(context).copyWith(color: Colors.white , fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            if (task.icon != null)
              Icon(task.icon, color: Colors.white, size: 20.0),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                task.taskName,
                style: AppTextStyles.caption(context).copyWith(
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
