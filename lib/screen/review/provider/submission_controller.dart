import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TaskSubmissionState {
  final bool isSubmitting;
  final bool isSubmissionSuccessful;

  TaskSubmissionState({
    this.isSubmitting = false,
    this.isSubmissionSuccessful = false,
  });

  TaskSubmissionState copyWith({
    bool? isSubmitting,
    bool? isSubmissionSuccessful,
  }) {
    return TaskSubmissionState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmissionSuccessful:
          isSubmissionSuccessful ?? this.isSubmissionSuccessful,
    );
  }

  factory TaskSubmissionState.initial() => TaskSubmissionState();
}

class TaskSubmissionController extends StateNotifier<TaskSubmissionState> {
  final Ref ref;

  TaskSubmissionController(this.ref)
      : super(TaskSubmissionState.initial());

  Future<void> submitTask(
    int taskNo,
    int trackId,
    DateTime startDate, {
    String? commitHash,
  }) async {
    try {
      state = state.copyWith(isSubmitting: true, isSubmissionSuccessful: false);

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    if (email == null) throw Exception('Email not found.');

      final body = jsonEncode({
        "track_id": trackId,
        "task_no": taskNo,
        "reference_link": "string",
        "start_date": _convertDate(startDate),
        "mentee_email": email,
        if (commitHash != null && commitHash.isNotEmpty) "commit_hash": commitHash,
      });

    final response = await http.post(
      Uri.parse('${dotenv.env['BACKEND_URL']}/progress/submit-task'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      state = state.copyWith(isSubmitting: false, isSubmissionSuccessful: true);
    } else if (response.statusCode == 409) {
      // 🔁 Duplicate submission
      throw Exception('You have already submitted this task.');
    } else {
      throw Exception('Submission failed with status ${response.statusCode}');
    }
  } catch (e) {
    print("Submission error: $e");
    state = state.copyWith(isSubmitting: false, isSubmissionSuccessful: false);
    rethrow; // So UI can catch and show proper message
  }
}

String _convertDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-"
         "${date.month.toString().padLeft(2, '0')}-"
         "${date.day.toString().padLeft(2, '0')}";
}
}

final taskSubmissionControllerProvider =
    StateNotifierProvider.family<TaskSubmissionController, TaskSubmissionState, int>(
  (ref, taskId) => TaskSubmissionController(ref),
);