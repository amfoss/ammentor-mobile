import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ammentor/screen/track/model/track_model.dart';
import 'package:ammentor/screen/review/model/review_model.dart';
import 'package:ammentor/screen/review/model/submission_model.dart';

/// -- API SERVICE -- ///
class ApiService {
  final String _baseUrl = dotenv.env['BACKEND_URL']!;

  Future<List<Track>> fetchTracks() async {
    final response = await http.get(Uri.parse('$_baseUrl/tracks/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((track) => Track.fromJson(track)).toList();
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  Future<List<ReviewTask>> fetchTasksForTrack(String trackId) async {
    final response = await http.get(Uri.parse('$_baseUrl/tracks/$trackId/tasks'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => ReviewTask.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

Future<List<Submission>> fetchUserSubmissions({
  required String email,
  required String trackId,
}) async {
  final uri = Uri.https(
    _baseUrl.replaceFirst('https://', ''),
    '/submissions/',
    {'email': email, 'track_id': trackId},
  );

  debugPrint('Encoded URL: $uri');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((task) => Submission.fromJson(task)).toList();
  } else {
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
    throw Exception('Failed to fetch submissions');
  }
}
}

/// -- PROVIDERS -- ///
final apiServiceProvider = Provider((ref) => ApiService());

final tracksProvider = FutureProvider<List<Track>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return api.fetchTracks();
});

final selectedTrackProvider = StateProvider<String?>((ref) => '1'); // Default: Vidyaratna

final emailProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('user_email');
  if (email == null) throw Exception('Email not found in local storage.');
  return email;
});

final activeTaskFilterProvider = StateProvider<String>((ref) => 'handin'); // or 'submissions'

/// -- TASK CONTROLLER: dynamic type allows both ReviewTask and Submission -- ///
class TaskReviewController extends StateNotifier<List<dynamic>> {
  final Ref ref;

  TaskReviewController(this.ref) : super([]) {
    _refresh();
    ref.listen(selectedTrackProvider, (_, __) => _refresh());
    ref.listen(activeTaskFilterProvider, (_, __) => _refresh());
  }

  void _refresh() {
    final trackId = ref.read(selectedTrackProvider);
    final filter = ref.read(activeTaskFilterProvider);
    if (trackId != null) {
      if (filter == 'handin') {
        fetchTasksForTrack(trackId);
      } else if (filter == 'submissions') {
        fetchUserSubmissionsForTrack(trackId);
      }
    }
  }

  Future<void> fetchTasksForTrack(String trackId) async {
    try {
      final api = ref.read(apiServiceProvider);
      final tasks = await api.fetchTasksForTrack(trackId);
      state = tasks;
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
      state = [];
    }
  }

  Future<void> fetchUserSubmissionsForTrack(String trackId) async {
    try {
      final api = ref.read(apiServiceProvider);
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      if (email == null) {
        throw Exception('Email not found in local storage.');
      }
      final submissions = await api.fetchUserSubmissions(email: email, trackId: trackId);
      state = submissions;
    } catch (e) {
      debugPrint('Error fetching submissions: $e');
      state = [];
    }
  }
}

final taskReviewControllerProvider =
    StateNotifierProvider<TaskReviewController, List<dynamic>>(
  (ref) => TaskReviewController(ref),
);

/// Optional: if you ever want just submissions directly
final submissionsProvider = FutureProvider.family<List<Submission>, String>((ref, trackId) async {
  final api = ref.read(apiServiceProvider);
  final email = await ref.watch(emailProvider.future);
  return api.fetchUserSubmissions(email: email, trackId: trackId);
});