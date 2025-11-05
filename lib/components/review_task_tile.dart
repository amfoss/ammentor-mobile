import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/mentee-submissions/model/review_model.dart';
import 'package:ammentor/screen/mentee-submissions/view/submission_screen.dart';

class ReviewTaskTile extends ConsumerWidget {
  final ReviewTask task;

  const ReviewTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.008),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (task.status == TaskStatus.submitted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskSubmissionScreen(task: task),
              ),
            );
          }
        },
        splashColor: Colors.white.withOpacity(0.04),
        highlightColor: Colors.white.withOpacity(0.02),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.025),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.07), width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Task Number Badge
              Container(
                width: w * 0.1,
                height: w * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${task.taskNumber}',
                  style: AppTextStyles.body(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              SizedBox(width: w * 0.04),

              // Task Title
              Expanded(
                child: Text(
                  task.taskName,
                  style: AppTextStyles.subheading(context).copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}