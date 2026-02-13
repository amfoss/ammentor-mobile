import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/mentor-evaluation/model/mentee_tasks_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final trackTasksProvider = FutureProvider.family<List<TrackTask>, int>((ref, trackId) async {
  final url = Uri.parse('${dotenv.env['BACKEND_URL']}/tracks/$trackId/tasks');
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
  int trackId,
  List<TrackTask> trackTasks,
) async {
  final url = Uri.parse('${dotenv.env['BACKEND_URL']}/submissions/?email=$menteeEmail&track_id=$trackId');
  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to load submissions');
  }

  final List<dynamic> data = jsonDecode(response.body);
  final submissions = data.map((e) => Submission.fromJson(e)).toList();

  final Map<int, Submission> latestSubmissions = {};
  for (final sub in submissions) {
    final existing = latestSubmissions[sub.taskNo];
    if (existing == null ||
        (sub.submittedAt != null &&
            (existing.submittedAt == null ||
             DateTime.tryParse(sub.submittedAt!)?.isAfter(DateTime.tryParse(existing.submittedAt ?? '') ?? DateTime(1970)) == true))) {
      latestSubmissions[sub.taskNo] = sub;
    }
  }

  final filtered = latestSubmissions.values.where((s) {
    final status = s.status.trim().toLowerCase();
    if (filter == 'pending') return status == 'submitted';
    if (filter == 'returned') return status == 'approved' || status == 'paused';
    return false;
  }).toList();
  
  filtered.sort((a,b) => a.taskNo.compareTo(b.taskNo));

  return filtered.map((s) {
    final trackTask = trackTasks.firstWhere(
      (t) => t.id == s.taskNo,
      orElse: () => TrackTask(
        id: s.taskNo,
        trackId: trackId,
        taskNo: -1,
        title: '${s.taskName}',
        description: '',
        points: 0,
        deadline: null,
      ),
    );
    return Task.fromSubmission(s, trackTask.title);
  }).toList();
}

final menteeTasksControllerProvider = FutureProvider.family<List<Task>, ({String email, String filter, int trackId})>((ref, input) async {
  final trackTasks = await ref.watch(trackTasksProvider(input.trackId).future);
  return fetchMenteeTasks(input.email, input.filter, input.trackId, trackTasks);
});

final menteeTaskFilterProvider = StateProvider<String>((ref) => 'pending');