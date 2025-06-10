import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/review/model/review_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final reviewTasksProvider = FutureProvider<List<ReviewTask>>((ref) async {
  final url = Uri.parse('${dotenv.env['BACKEND_URL']}/review/tasks');
  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to load review tasks');
  }
  final List<dynamic> data = jsonDecode(response.body);
  return data.map((e) => ReviewTask.fromJson(e)).toList();
});

final activeTaskFilterProvider = StateProvider<String>((ref) => 'notreviewed');

final filteredReviewTasksProvider = Provider<List<ReviewTask>>((ref) {
  final tasksAsync = ref.watch(reviewTasksProvider);
  final filter = ref.watch(activeTaskFilterProvider);

  return tasksAsync.maybeWhen(
    data: (tasks) {
      if (filter == 'notreviewed') {
        return tasks.where((task) => task.status == TaskStatus.notreviewed).toList();
      } else if (filter == 'reviewed') {
        return tasks.where((task) => task.status == TaskStatus.reviewed).toList();
      }
      return tasks;
    },
    orElse: () => [],
  );
});
