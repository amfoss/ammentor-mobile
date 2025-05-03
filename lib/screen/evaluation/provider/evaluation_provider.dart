import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/model/evaluation_model.dart';
import 'package:ammentor/screen/evaluation/model/mentee_tasks_model.dart';

class TaskEvaluationController extends StateNotifier<Evaluation?> {
  final Task task;

  TaskEvaluationController(this.task, Evaluation? initialEvaluation)
    : super(initialEvaluation);

  void updateFeedback(String feedback) {
    state =
        state?.copyWith(feedback: feedback) ??
        Evaluation(status: EvaluationStatus.returned, feedback: feedback);
  }

  void updateScore(int? score) {
    state = state?.copyWith(score: score);
  }

  void updateStatus(EvaluationStatus status) {
    state = state?.copyWith(status: status) ?? Evaluation(status: status);
  }

  Future<void> submitEvaluation() async {}
}

final taskEvaluationControllerProvider =
    StateNotifierProvider.family<TaskEvaluationController, Evaluation?, Task>((
      ref,
      task,
    ) {
      return TaskEvaluationController(task, null);
    });

extension EvaluationCopyWith on Evaluation {
  Evaluation copyWith({
    String? feedback,
    int? score,
    EvaluationStatus? status,
  }) {
    return Evaluation(
      feedback: feedback ?? this.feedback,
      status: status ?? this.status,
    );
  }
}
