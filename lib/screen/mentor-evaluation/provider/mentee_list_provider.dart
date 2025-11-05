import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/mentor-evaluation/model/mentee_list_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<int> fetchMenteePoints(String email) async {
  final url = Uri.parse('${dotenv.env['BACKEND_URL']}/auth/user/$email');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['total_points'] ?? 0;
  }
  return 0;
}

final menteeListControllerProvider = FutureProvider<List<Mentee>>((ref) async {
  final storage = FlutterSecureStorage();
  final mentorEmail = await storage.read(key: 'userEmail');
  if (mentorEmail == null) {
    return [];
  }
  final url = Uri.parse('${dotenv.env['BACKEND_URL']}/mentors/$mentorEmail/mentees');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final menteesRaw = (data['mentees'] as List);
    final mentees = await Future.wait(menteesRaw.map((e) async {
      final points = await fetchMenteePoints(e['email']);
      return Mentee(
        id: e['email'],
        name: e['name'],
        imageUrl: 'https://github.com/amfoss.png',
        totalPoints: points,
      );
    }));
    return mentees;
  } else {
    throw Exception('Failed to load mentees');
  }
});
