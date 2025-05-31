import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/leaderboard/model/leaderboard_model.dart';

final baseUrl = dotenv.env['BACKEND_URL'];

final trackListProvider = FutureProvider<List<Track>>((ref) async {
  final response = await http.get(Uri.parse('$baseUrl/tracks/'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((t) => Track.fromJson(t)).toList();
  } else {
    throw Exception('Failed to fetch tracks');
  }
});

final selectedTrackProvider = StateProvider<Track?>((ref) => null);

final leaderboardProvider =
    FutureProvider.family<List<LeaderboardUser>, int>((ref, trackId) async {
  final response = await http.get(Uri.parse('$baseUrl/leaderboard/$trackId'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> users = data['leaderboard'];
    return users.map((u) => LeaderboardUser.fromJson(u)).toList();
  } else {
    throw Exception('Failed to fetch leaderboard');
  }
});
