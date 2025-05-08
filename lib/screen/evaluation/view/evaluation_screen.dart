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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Evaluation',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Text(
                //   '${widget.task.taskNumber}',
                //   style: AppTextStyles.label(context).copyWith(color: AppColors.white),
                // ),
                // SizedBox(width: screenWidth * 0.02),
                Icon(widget.task.icon, color: AppColors.grey),
                SizedBox(width: screenWidth * 0.02),
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
              child: Divider(
                color: AppColors.grey,
                thickness: 1.0,
              ),
            ),
            Text(
              'Submission:',
              style: AppTextStyles.label(context).copyWith(color: AppColors.white70),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildSubmissionDetail(
              HugeIcons.strokeRoundedComment01,
              'I have finished the work',
            ),
            _buildSubmissionDetail(
              HugeIcons.strokeRoundedSunrise,
              '28/05/2025',
            ),
            _buildSubmissionDetail(
              HugeIcons.strokeRoundedSunset,
              '29/05/2025',
            ),
            _buildSubmissionDetail(
              HugeIcons.strokeRoundedLink01,
              'https://www.github.com',
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedCommentAdd01,
                  color: AppColors.grey,
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Remarks',
                  style: AppTextStyles.label(context).copyWith(color: AppColors.white70),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            TextFormField(
              controller: _remarksController,
              style: AppTextStyles.input(context),
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
                hintStyle: AppTextStyles.input(context).copyWith(color: AppColors.grey),
              ),
              onChanged: (value) => evaluationController.updateFeedback(value),
            ),
            SizedBox(height: screenHeight * 0.03),
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
                    style: AppTextStyles.button(context).copyWith(fontSize: screenWidth * 0.04),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Pause task',
                    style: AppTextStyles.button(context).copyWith(fontSize: screenWidth * 0.04),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey),
          SizedBox(width: screenWidth * 0.02),
          Text(
            text,
            style: AppTextStyles.caption(context).copyWith(),
          ),
        ],
      ),
    );
  }
}