import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  Future<List<Task>> fetchTasksForTrack(String trackId) async {
    final url = '$_baseUrl/tracks/$trackId/tasks';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((task) => Task.fromJson(task)).toList();
      } else {
        throw Exception('Failed to load tasks for track $trackId. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}


final apiServiceProvider = Provider((ref) => ApiService());

final tracksProvider =
    AsyncNotifierProvider<TracksNotifier, List<Track>>(() {
  return TracksNotifier();
});

class TracksNotifier extends AsyncNotifier<List<Track>> {
  @override
  Future<List<Track>> build() async {
    final apiService = ref.read(apiServiceProvider);
    final tracks = await apiService.fetchTracks();
    return tracks;
  }

  Future<void> fetchTasksForTrack(String trackId) async {
    if (state is! AsyncData) {
      await ref.read(tracksProvider.notifier).build();
      if (state is! AsyncData) {
        return;
      }
    }

    List<Track> currentTracks = state.value!;

    int trackIndex = currentTracks.indexWhere((track) => track.id == trackId);
    if (trackIndex == -1) {
      return;
    }

    try {
      final apiService = ref.read(apiServiceProvider);
      final tasks = await apiService.fetchTasksForTrack(trackId);

      List<Track> updatedTracks = List.from(currentTracks);
      updatedTracks[trackIndex] = Track(
        id: currentTracks[trackIndex].id,
        name: currentTracks[trackIndex].name,
        description: currentTracks[trackIndex].description,
        imageUrl: currentTracks[trackIndex].imageUrl,
        tasks: tasks,
      );

      state = AsyncData(updatedTracks);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}