import 'package:flutter/material.dart';

enum TaskStatus { pending, returned }

class Task {
  final int taskNumber;
  final IconData icon;
  final String taskName;
  final TaskStatus status;

  Task({
    required this.taskNumber,
    required this.icon,
    required this.taskName,
    required this.status,
  });
}
