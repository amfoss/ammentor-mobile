import 'package:ammentor/components/custom_calender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/submission_input_row.dart';
import 'package:ammentor/screen/mentee-submissions/model/review_model.dart';
import 'package:ammentor/screen/mentee-submissions/provider/submission_controller.dart';


class TaskSubmissionScreen extends ConsumerStatefulWidget {
  final ReviewTask task;

  const TaskSubmissionScreen({super.key, required this.task});

  @override
  ConsumerState<TaskSubmissionScreen> createState() => _TaskSubmissionScreenState();
}

class _TaskSubmissionScreenState extends ConsumerState<TaskSubmissionScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _submissionLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final submissionState = ref.watch(taskSubmissionControllerProvider(widget.task.taskNumber));
    final controller = ref.read(taskSubmissionControllerProvider(widget.task.taskNumber).notifier);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Submission', style: AppTextStyles.subheading(context).copyWith(color: AppColors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Text(
                    widget.task.taskName,
                    style: AppTextStyles.subheading(context).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03, child: Divider(color: AppColors.grey, thickness: 1.0)),
            SubmissionInputRow(
              icon: HugeIcons.strokeRoundedSunrise,
              text: 'Starting date',
              controller: _startDateController,
              readOnly: true,
              onTap: () async {
                await showModernCalendarPicker(
                  context: context,
                  selectedDate: DateTime.now(),
                  onDateSelected: (pickedDate) {
                    _startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  },
                );
              },
            ),
            SizedBox(height: screenHeight * 0.012),
            SubmissionInputRow(
              icon: HugeIcons.strokeRoundedLink01,
              text: 'Submission link',
              controller: _submissionLinkController,
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.024),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submissionState.isSubmitting
                      ? null
                      : () async {
                          try {
                            final DateTime parsedStartDate = DateTime.parse(_startDateController.text);
                            final int trackId = widget.task.trackId;

                            await controller.submitTask(
                              widget.task.taskNumber,
                              trackId,
                              _submissionLinkController.text,
                              parsedStartDate,
                            );

                            if (ref.read(taskSubmissionControllerProvider(widget.task.taskNumber)).isSubmissionSuccessful) {
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Submission failed. Please try again.')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid input: ${e.toString()}')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                  ),
                  child: submissionState.isSubmitting
                      ? const CircularProgressIndicator()
                      : Text('Submit for review', style: AppTextStyles.button(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}