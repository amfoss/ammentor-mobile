import 'package:flutter/material.dart';

class Track {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Task> tasks;

  Track({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.tasks = const [],
  });

  double get progress {
    if (tasks.isEmpty) {
      return 0.0;
    }
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length * 100;
  }
}

class Task {
  final int taskNumber;
  final IconData icon;
  final String taskName;
  final int points;
  final bool isCompleted;

  Task({
    required this.taskNumber,
    required this.icon,
    required this.taskName,
    required this.points,
    this.isCompleted = false,
  });
}
