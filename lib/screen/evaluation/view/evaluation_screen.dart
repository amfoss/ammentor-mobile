import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/model/evaluation_model.dart';
import 'package:ammentor/screen/evaluation/model/mentee_tasks_model.dart';
import 'package:ammentor/screen/evaluation/provider/evaluation_provider.dart';

class TaskEvaluationScreen extends ConsumerStatefulWidget {
  final Task task;

  const TaskEvaluationScreen({super.key, required this.task});

  @override
  ConsumerState<TaskEvaluationScreen> createState() =>
      _TaskEvaluationScreenState();
}

class _TaskEvaluationScreenState extends ConsumerState<TaskEvaluationScreen> {
  final _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final existingEvaluation = ref.read(
      taskEvaluationControllerProvider(widget.task),
    );
    if (existingEvaluation != null && existingEvaluation.feedback != null) {
      _remarksController.text = existingEvaluation.feedback!;
    }
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final evaluationController = ref.read(
      taskEvaluationControllerProvider(widget.task).notifier,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Evaluation',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${widget.task.taskNumber}',
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                const SizedBox(width: 8.0),
                Icon(widget.task.icon, color: AppColors.grey),
                const SizedBox(width: 8.0),
                Text(
                  widget.task.taskName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Submission:',
              style: TextStyle(fontSize: 16.0, color: AppColors.white70),
            ),
            const SizedBox(height: 8.0),

            // The static data below is to be fetched from database.
            _buildSubmissionDetail(
              HugeIcons.strokeRoundedComment01,
              'I have finished the work',
            ),
            _buildSubmissionDetail(
              HugeIcons.strokeRoundedSunrise,
              '28/05/2025',
            ),
            _buildSubmissionDetail(HugeIcons.strokeRoundedSunset, '29/05/2025'),
            _buildSubmissionDetail(
              HugeIcons.strokeRoundedLink01,
              'https://www.github.com',
            ),
            const SizedBox(height: 24.0),
            const Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedCommentAdd01,
                  color: AppColors.grey,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Remarks',
                  style: TextStyle(fontSize: 16.0, color: AppColors.white70),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _remarksController,
              style: const TextStyle(color: AppColors.white),
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppColors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                fillColor: AppColors.surface,
                filled: true,
                hintText: 'Type your remarks here...',
                hintStyle: const TextStyle(color: AppColors.grey),
              ),
              onChanged: (value) => evaluationController.updateFeedback(value),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    evaluationController.updateStatus(
                      EvaluationStatus.returned,
                    );
                    evaluationController.submitEvaluation();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Evaluate and return',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    evaluationController.updateStatus(EvaluationStatus.paused);
                    evaluationController.submitEvaluation();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Pause task',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
