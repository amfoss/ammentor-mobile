import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/mentee-submissions/model/submission_model.dart';
import 'package:ammentor/screen/mentee-submissions/view/submission_details_screen.dart';

class SubmissionTile extends StatelessWidget {
  final Submission submission;

  const SubmissionTile({super.key, required this.submission});

  List<Color> getGradient(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return [Color(0xFFd1f5d3), Color(0xFFb6ebc1)]; 
      case 'submitted':
        return [Color(0xFFfdf6e3), Color(0xFFf5ecd2)]; 
      case 'rejected':
        return [Color(0xFFfde8e6), Color(0xFFf9d1cf)]; 
      default:
        return [AppColors.cardBackground, AppColors.cardBackground];
    }
  }

Color getTextColor(String status) {
  switch (status.toLowerCase()) {
    case 'approved':
    case 'submitted':
      return Colors.black;
    case 'rejected':
    default:
      return Colors.white;
  }
}
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final gradient = getGradient(submission.status);
    final textColor = getTextColor(submission.status);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SubmissionDetailsScreen(submission: submission),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.008),
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.018),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Task number badge
            Container(
              width: w * 0.1,
              height: w * 0.1,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${submission.taskNo}',
                style: AppTextStyles.body(context).copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),

            SizedBox(width: w * 0.04),

            // Task name
            Expanded(
              child: Text(
                submission.taskName.isNotEmpty
                    ? submission.taskName
                    : "Task ${submission.taskNo}",
                style: AppTextStyles.subheading(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontSize: 16,
                ),
              ),
            ),

            SizedBox(width: w * 0.02),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                StringExtension(submission.status).capitalize(),
                style: AppTextStyles.caption(context).copyWith(
                  color: textColor,
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