import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/mentor-evaluation/model/mentee_tasks_model.dart';
import 'package:ammentor/screen/mentor-evaluation/provider/evaluation_provider.dart';
import 'package:ammentor/components/link_text.dart';

/// Updated to accept trackId dynamically
final submissionProvider = FutureProvider.family<
  Map<String, dynamic>?,
  (String, int, int)
>((ref, params) async {
  final menteeEmail = params.$1;
  final submissionId = params.$2;
  final trackId = params.$3;

  final url = Uri.parse(
    '${dotenv.env['BACKEND_URL']}/submissions/?email=$menteeEmail&track_id=$trackId',
  );
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> submissions = jsonDecode(response.body);
    final found = submissions.firstWhere(
      (e) => e['id'] == submissionId,
      orElse: () => null,
    );
    return found;
  }
  return null;
});

class TaskEvaluationViewScreen extends ConsumerStatefulWidget {
  final Task task;
  final String menteeEmail;
  final int trackId;
  final VoidCallback? onTaskEvaluated;

  const TaskEvaluationViewScreen({
    super.key,
    required this.task,
    required this.menteeEmail,
    required this.trackId,
    this.onTaskEvaluated,
  });

  @override
  ConsumerState<TaskEvaluationViewScreen> createState() =>
      _TaskEvaluationViewScreenState();
}

class _TaskEvaluationViewScreenState
    extends ConsumerState<TaskEvaluationViewScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.invalidate(
      submissionProvider((
        widget.menteeEmail,
        widget.task.submissionId,
        widget.trackId,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final submissionAsync = ref.watch(
      submissionProvider((
        widget.menteeEmail,
        widget.task.submissionId,
        widget.trackId,
      )),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Task Details', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: submissionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, _) => const Center(
              child: Text(
                'Failed to load submission',
                style: TextStyle(color: Colors.white),
              ),
            ),
        data: (submissionData) {
          if (submissionData == null) {
            return const Center(
              child: Text(
                'Submission not found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final statusRaw =
              (submissionData['status'] ?? '').toString().toLowerCase();
          final mentorFeedback = submissionData['mentor_feedback'] ?? '';
          final startDate = submissionData['start_date'];
          final submittedAt = submissionData['submitted_at'];
          final referenceLink = submissionData['reference_link'];
          final approvedAt = submissionData['approved_at'];

          String statusText;
          if (statusRaw == 'approved') {
            statusText = "Approved";
          } else if (statusRaw == 'paused') {
            statusText = "Paused";
          } else if (statusRaw == 'submitted') {
            statusText = "Pending";
          } else {
            statusText = statusRaw;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.task.taskName,
                      style: AppTextStyles.heading(context).copyWith(
                        fontSize: screenHeight * 0.03,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                  child: Divider(color: AppColors.grey, thickness: 1.0),
                ),
                Text(
                  'Submission:',
                  style: AppTextStyles.label(
                    context,
                  ).copyWith(color: AppColors.white70),
                ),
                SizedBox(height: screenHeight * 0.01),
                _buildSubmissionDetail(
                  HugeIcons.strokeRoundedSunrise,
                  startDate ?? "No start date",
                  context,
                ),
                _buildSubmissionDetail(
                  HugeIcons.strokeRoundedSunset,
                  submittedAt ?? "No submission date",
                  context,
                ),
                _buildSubmissionDetail(
                  HugeIcons.strokeRoundedLink01,
                  referenceLink ?? "No link",
                  context,
                ),
                _buildSubmissionDetail(
                  HugeIcons.strokeRoundedCheckmarkBadge02,
                  "Status: $statusText",
                  context,
                ),
                if (mentorFeedback != null &&
                    mentorFeedback.toString().isNotEmpty &&
                    mentorFeedback.toString() != "null")
                  _buildSubmissionDetail(
                    HugeIcons.strokeRoundedComment01,
                    "Mentor Remark: $mentorFeedback",
                    context,
                  ),
                SizedBox(height: screenHeight * 0.03),
                if (statusRaw == "paused")
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final evaluationController = ref.read(
                          taskEvaluationControllerProvider(
                            widget.task,
                          ).notifier,
                        );
                        await evaluationController.submitEvaluation(
                          status: "approved",
                        );

                        int popCount = 0;
                        Navigator.of(context).popUntil((route) {
                          popCount++;
                          return popCount >= 2 || route.isFirst;
                        });

                        if (widget.onTaskEvaluated != null) {
                          widget.onTaskEvaluated!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.01,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Evaluate and return',
                        style: AppTextStyles.button(
                          context,
                        ).copyWith(fontSize: screenWidth * 0.04),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmissionDetail(
    IconData icon,
    String text,
    BuildContext context,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Row(
          children: [
            Icon(icon, color: AppColors.grey),
            SizedBox(width: screenWidth * 0.02),
            Flexible(
              child: LinkText(
                text: text,
                style: AppTextStyles.caption(context).copyWith(
                  color: Colors.white,
                ),
                maxLines: 3,
              ),
            ),
          ],
        ),
      );
  }
}
