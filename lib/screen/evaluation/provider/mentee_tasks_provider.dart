import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/model/mentee_tasks_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final trackTasksProvider = FutureProvider<List<TrackTask>>((ref) async {
  final url = Uri.parse('${dotenv.env['BACKEND_URL']}/tracks/1/tasks');
  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to load track tasks');
  }
  final List<dynamic> data = jsonDecode(response.body);
  return data.map((e) => TrackTask.fromJson(e)).toList();
});

Future<List<Task>> fetchMenteeTasks(
  String menteeEmail,
  String filter,
  List<TrackTask> trackTasks,
) async {
  final url = Uri.parse('${dotenv.env['BACKEND_URL']}/submissions/?email=$menteeEmail&track_id=1');
  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to load submissions');
  }
  final List<dynamic> data = jsonDecode(response.body);
  final submissions = data.map((e) => Submission.fromJson(e)).toList();

  final Map<int, Submission> latestSubmissions = {};
  for (final sub in submissions) {
    final existing = latestSubmissions[sub.taskId];
    if (existing == null ||
        (sub.submittedAt != null &&
         (existing.submittedAt == null ||
          DateTime.tryParse(sub.submittedAt!)?.isAfter(DateTime.tryParse(existing.submittedAt ?? '') ?? DateTime(1970)) == true))) {
      latestSubmissions[sub.taskId] = sub;
    }
  }

  final filtered = latestSubmissions.values.where((s) {
    if (filter == 'pending') {
      return s.status.trim().toLowerCase() == 'submitted';
    } else if (filter == 'returned') {
      final status = s.status.trim().toLowerCase();
      return status == 'approved' || status == 'paused';
    }
    return false;
  }).toList();

  return filtered.map((s) {
    final trackTask = trackTasks.firstWhere(
      (t) => t.id == s.taskId,
      orElse: () => TrackTask(
        id: s.taskId,
        trackId: 1,
        taskNo: -1,
        title: 'Task ${s.taskId}',
        description: '',
        points: 0,
        deadline: null,
      ),
    );
    return Task.fromSubmission(s, trackTask.title);
  }).toList();
}

final menteeTasksControllerProvider = FutureProvider.family<List<Task>, String>((ref, key) async {
  final parts = key.split('-');
  final menteeId = parts.first;
  final filter = parts.sublist(1).join('-');
  final trackTasksAsync = await ref.watch(trackTasksProvider.future);
  return fetchMenteeTasks(menteeId, filter, trackTasksAsync);
});

final menteeTaskFilterProvider = StateProvider<String>((ref) => 'pending');
