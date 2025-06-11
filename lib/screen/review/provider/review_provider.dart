import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ammentor/screen/review/model/review_model.dart';
import 'package:ammentor/screen/track/model/track_model.dart';

class ApiService {
  final String _baseUrl = dotenv.env['BACKEND_URL']!;

  Future<List<Track>> fetchTracks() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/tracks/'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((track) => Track.fromJson(track)).toList();
      } else {
        throw Exception('Failed to load tracks. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ReviewTask>> fetchTasksForTrack(String trackId) async {
    final url = '$_baseUrl/tracks/$trackId/tasks';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((task) => ReviewTask(
          taskNumber: task['id'],
          icon: null, // Replace with appropriate icon logic if needed
          taskName: task['name'],
          status: TaskStatus.notreviewed, // Default status
        )).toList();
      } else {
        throw Exception('Failed to load tasks for track $trackId. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

final apiServiceProvider = Provider((ref) => ApiService());

final tracksProvider = FutureProvider<List<Track>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.fetchTracks();
});

final selectedTrackProvider = StateProvider<String?>((ref) => null);

final tasksProvider = FutureProvider.family<List<ReviewTask>, String>((ref, trackId) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.fetchTasksForTrack(trackId);
});

class TaskReviewController extends StateNotifier<List<ReviewTask>> {
  final Ref ref;

  TaskReviewController(this.ref) : super([]) {
    ref.listen<String?>(selectedTrackProvider, (previous, next) {
      if (next != null) {
        fetchTasksForTrack(next);
      }
    });
  }

  Future<void> fetchTasksForTrack(String trackId) async {
    final apiService = ref.read(apiServiceProvider);
    final tasks = await apiService.fetchTasksForTrack(trackId);
    state = tasks;
  }

  void filterTasks(String status) {
    if (status == 'notreviewed') {
      state = state.where((task) => task.status == TaskStatus.notreviewed).toList();
    } else if (status == 'reviewed') {
      state = state.where((task) => task.status == TaskStatus.reviewed).toList();
    }
  }
}

final taskReviewControllerProvider =
    StateNotifierProvider<TaskReviewController, List<ReviewTask>>((ref) {
      return TaskReviewController(ref);
    });

final activeTaskFilterProvider = StateProvider<String>((ref) => 'notreviewed');
