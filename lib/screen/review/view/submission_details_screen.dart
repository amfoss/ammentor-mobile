import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Don't forget to add to pubspec.yaml
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/review/model/submission_model.dart';

class SubmissionDetailsScreen extends StatelessWidget {
  final Submission submission;

  const SubmissionDetailsScreen({super.key, required this.submission});

  String formatDate(DateTime? date) {
    if (date == null) return 'Pending';
    return DateFormat('dd MMM yyyy').format(date);
  }

  Widget buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool isLink = false,
    bool isStatus = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.caption(context)
                        .copyWith(color: Colors.grey[400])),
                const SizedBox(height: 6),
                isStatus
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: value.toLowerCase() == 'approved'
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          value.capitalize(),
                          style: AppTextStyles.caption(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : isLink
                        ? GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse(value);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Text(
                              value,
                              style: AppTextStyles.link(context),
                            ),
                          )
                        : Text(
                            value,
                            style: AppTextStyles.body(context).copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Submission Details',
          style: AppTextStyles.subheading(context),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoCard(context, 'Task Name', submission.taskName, Icons.task),
            buildInfoCard(context, 'Task ID', submission.taskId.toString(), Icons.tag),
            buildInfoCard(context, 'Submission Link', submission.referenceLink, Icons.link, isLink: true),
            buildInfoCard(context, 'Status', submission.status, Icons.info, isStatus: true),
            buildInfoCard(context, 'Start Date', formatDate(submission.startDate), Icons.event),
            buildInfoCard(context, 'Submitted At', formatDate(submission.submittedAt), Icons.upload),
            buildInfoCard(context, 'Approved At', formatDate(submission.approvedAt), Icons.verified),
            buildInfoCard(
              context,
              'Mentor Feedback',
              submission.mentorFeedback.isEmpty ? 'No feedback given' : submission.mentorFeedback,
              Icons.feedback,
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() =>
      isEmpty ? this : this[0].toUpperCase() + substring(1).toLowerCase();
}