import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskSubmissionState {
  final bool isSubmitting;
  final bool isSubmissionSuccessful;

  TaskSubmissionState({
    this.isSubmitting = false,
    this.isSubmissionSuccessful = false,
  });

  TaskSubmissionState copyWith({
    bool? isSubmitting,
    String? submissionResult,
    bool? isSubmissionSuccessful,
  }) {
    return TaskSubmissionState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmissionSuccessful:
          isSubmissionSuccessful ?? this.isSubmissionSuccessful,
    );
  }
}

class TaskSubmissionController extends StateNotifier<TaskSubmissionState> {
  final int taskId;

  TaskSubmissionController(this.taskId) : super(TaskSubmissionState());

  Future<void> submitTask(
    int taskId,
    String comments,
    String startDate,
    String endDate,
    String submissionLink,
  ) async {
    state = state.copyWith(isSubmitting: true, isSubmissionSuccessful: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isSubmitting: false, isSubmissionSuccessful: true);
  }
}

final taskSubmissionControllerProvider = StateNotifierProvider.family<
  TaskSubmissionController,
  TaskSubmissionState,
  int
>((ref, taskId) {
  return TaskSubmissionController(taskId);
});
