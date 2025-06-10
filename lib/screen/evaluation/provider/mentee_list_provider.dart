import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/model/mentee_list_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    final mentees = (data['mentees'] as List)
        .map((e) => Mentee(
              id: e['email'],
              name: e['name'],
              imageUrl: 'https://github.com/amfoss.png',
            ))
        .toList();
    return mentees;
  } else {
    throw Exception('Failed to load mentees');
  }
});
