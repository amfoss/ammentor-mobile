import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ammentor/screen/track/model/track_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tracksProvider = FutureProvider<List<Track>>((ref) async {
  final response = await http.get(Uri.parse('http://4.240.104.190/tracks'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((json) => Track.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load tracks');
  }
});

final tasksProvider = FutureProvider.family<List<Task>, int>((ref, trackId) async {
  final response = await http.get(Uri.parse('http://4.240.104.190/tracks/$trackId/tasks'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((json) => Task.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load tasks for track $trackId');
  }
});
