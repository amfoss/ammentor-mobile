import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/review/model/submission_model.dart';
import 'package:ammentor/screen/review/view/submission_details_screen.dart';

class SubmissionTile extends StatelessWidget {
  final Submission submission;

  const SubmissionTile({super.key, required this.submission});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.green;
      case 'submitted':
        return AppColors.orange;
      case 'rejected':
        return AppColors.red;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SubmissionDetailsScreen(submission: submission),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.border.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.1,
              height: screenHeight * 0.035,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.grey[800],
              ),
              child: Text(
                '${submission.taskId}',
                style: AppTextStyles.caption(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                submission.taskName.isNotEmpty
                    ? submission.taskName
                    : "Task ${submission.taskId}",
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.02),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: getStatusColor(submission.status),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                StringExtension(submission.status).capitalize(),
                style: AppTextStyles.caption(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}