import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final Color cardColor = Colors.white.withOpacity(0.025);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption(context).copyWith(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                isStatus
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: value.toLowerCase() == 'approved'
                                ? [Colors.greenAccent.withOpacity(0.3), Colors.green]
                                : value.toLowerCase() == 'submitted'
                                    ? [Colors.yellow.shade100, Colors.yellow.shade600]
                                    : [Colors.redAccent.withOpacity(0.3), Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          value.capitalize(),
                          style: AppTextStyles.caption(context).copyWith(
                            color: value.toLowerCase() == 'submitted'
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
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
                              style: AppTextStyles.link(context).copyWith(fontWeight: FontWeight.w500),
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
            buildInfoCard(context, 'Task No', submission.taskId.toString(), Icons.tag),
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
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1).toLowerCase();
}
