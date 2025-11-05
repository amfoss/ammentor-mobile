import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/mentor-evaluation/model/evaluation_model.dart';
import 'package:ammentor/screen/mentor-evaluation/model/mentee_tasks_model.dart';
import 'package:ammentor/screen/mentor-evaluation/provider/evaluation_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskEvaluationScreen extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback? onEvaluated;

  const TaskEvaluationScreen({super.key, required this.task, this.onEvaluated});

  @override
  ConsumerState<TaskEvaluationScreen> createState() => _TaskEvaluationScreenState();
}

class _TaskEvaluationScreenState extends ConsumerState<TaskEvaluationScreen> {
  final _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final existingEvaluation = ref.read(
      taskEvaluationControllerProvider(widget.task),
    );
    if (existingEvaluation?.feedback != null) {
      _remarksController.text = existingEvaluation!.feedback!;
    }
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _handleEvaluation(BuildContext context, String status) async {
    final controller = ref.read(taskEvaluationControllerProvider(widget.task).notifier);
    if (status == "approved") {
      controller.updateStatus(EvaluationStatus.returned);
    } else if (status == "paused") {
      controller.updateStatus(EvaluationStatus.paused);
    }
    await controller.submitEvaluation(status: status);
    widget.onEvaluated?.call();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Evaluation', style: AppTextStyles.subheading(context).copyWith(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.taskName,
              style: AppTextStyles.heading(context).copyWith(
                fontSize: h * 0.03,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: h * 0.02),
            _buildMetaItem(HugeIcons.strokeRoundedSunrise, widget.task.startDate ?? "No start date"),
            _buildMetaItem(HugeIcons.strokeRoundedSunset, widget.task.submittedAt ?? "No submission date"),
            _buildMetaItem(HugeIcons.strokeRoundedLink01, widget.task.referenceLink ?? "No link"),
            SizedBox(height: h * 0.03),
            Text(
              'Remarks',
              style: AppTextStyles.label(context).copyWith(color: AppColors.grey),
            ),
            SizedBox(height: h * 0.01),

            TextFormField(
              controller: _remarksController,
              onChanged: (val) =>
                  ref.read(taskEvaluationControllerProvider(widget.task).notifier).updateFeedback(val),
              maxLines: 6,
              style: AppTextStyles.input(context).copyWith(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(w * 0.04),
                filled: true,
                fillColor: Colors.white.withOpacity(0.03),
                hintText: 'Type your remarks...',
                hintStyle: AppTextStyles.input(context).copyWith(
                  color: Colors.white.withOpacity(0.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleEvaluation(context, 'approved'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: EdgeInsets.symmetric(vertical: h * 0.018),
                    ),
                    child: Text(
                      'Return Task',
                      style: AppTextStyles.button(context).copyWith(fontSize: w * 0.04),
                    ),
                  ),
                ),
                SizedBox(width: w * 0.04),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleEvaluation(context, 'paused'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: EdgeInsets.symmetric(vertical: h * 0.018),
                    ),
                    child: Text(
                      'Pause Task',
                      style: AppTextStyles.button(context).copyWith(fontSize: w * 0.04),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final isLink = text.startsWith("http");

    Future<void> _openLink(String url) async {
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid or unreachable link")),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.01),
      child: InkWell(
        onTap: isLink ? () => _openLink(text) : null,
        child: Row(
          children: [
            Icon(icon, size: w * 0.048, color: AppColors.grey),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption(context).copyWith(
                  color: isLink ? Colors.blue : Colors.white,
                  decoration: isLink ? TextDecoration.underline : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}