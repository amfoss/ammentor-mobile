import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/review/model/review_model.dart';
import 'package:ammentor/screen/review/provider/submission_controller.dart';

class TaskSubmissionScreen extends ConsumerStatefulWidget {
  final ReviewTask task;

  const TaskSubmissionScreen({super.key, required this.task});

  @override
  ConsumerState<TaskSubmissionScreen> createState() =>
      _TaskSubmissionScreenState();
}

class _TaskSubmissionScreenState extends ConsumerState<TaskSubmissionScreen> {
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _submissionLinkController =
      TextEditingController();

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.grey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final submissionState = ref.watch(
      taskSubmissionControllerProvider(widget.task.taskNumber),
    );
    final controller = ref.read(
      taskSubmissionControllerProvider(widget.task.taskNumber).notifier,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Submission',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: AppColors.cardBackground,
                  ),
                  child: Text(
                    '${widget.task.taskNumber}',
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
                const SizedBox(width: 12.0),
                if (widget.task.icon != null)
                  Icon(widget.task.icon, color: Colors.white, size: 20.0),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    widget.task.taskName,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            _SubmissionRow(
              icon: HugeIcons.strokeRoundedComment01,
              text: 'Remarks',
              controller: _commentsController,
            ),
            const SizedBox(height: 8.0),
            _SubmissionRow(
              icon: HugeIcons.strokeRoundedSunrise,
              text: 'Starting date',
              controller: _startDateController,
              readOnly: true,
              onTap: () => _selectDate(context, _startDateController),
            ),
            const SizedBox(height: 8.0),
            _SubmissionRow(
              icon: HugeIcons.strokeRoundedSunset,
              text: 'Ending date',
              controller: _endDateController,
              readOnly: true,
              onTap: () => _selectDate(context, _endDateController),
            ),
            const SizedBox(height: 8.0),
            _SubmissionRow(
              icon: HugeIcons.strokeRoundedLink01,
              text: 'Submission link',
              controller: _submissionLinkController,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      submissionState.isSubmitting
                          ? null
                          : () {
                            controller.submitTask(
                              widget.task.taskNumber,
                              _commentsController.text,
                              _startDateController.text,
                              _endDateController.text,
                              _submissionLinkController.text,
                            );
                            if (submissionState.isSubmissionSuccessful) {
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Submission failed. Please try again.',
                                  ),
                                ),
                              );
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child:
                      submissionState.isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text(
                            'Submit for review',
                            style: TextStyle(fontSize: 18.0),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmissionRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;

  const _SubmissionRow({
    required this.icon,
    required this.text,
    this.controller,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16.0),
            Expanded(
              child:
                  controller != null
                      ? TextField(
                        controller: controller,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                          hintText: text,
                          hintStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                          border: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        readOnly: readOnly,
                        onTap: onTap,
                        cursorColor: AppColors.primary,
                      )
                      : Text(
                        text,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16.0,
                        ),
                      ),
            ),
            if (onTap != null)
              const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
