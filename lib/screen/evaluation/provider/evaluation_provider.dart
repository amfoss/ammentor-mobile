import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/model/evaluation_model.dart';
import 'package:ammentor/screen/evaluation/model/mentee_tasks_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
final selectedTrackProvider = StateProvider<String?>((ref) => null);
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

  Future<void> submitEvaluation({String status = "approved"}) async {
    final storage = FlutterSecureStorage();
    final mentorEmail = await storage.read(key: 'userEmail');
    final feedback = state?.feedback ?? '';
    final submissionId = task.submissionId;

    final url = Uri.parse('${dotenv.env['BACKEND_URL']}/progress/approve-task');
    final body = jsonEncode({
      "submission_id": submissionId,
      "mentor_email": mentorEmail,
      "status": status,
      "mentor_feedback": feedback,
    });

    await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }
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
