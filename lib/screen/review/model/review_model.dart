import 'package:flutter/material.dart';

enum TaskStatus { reviewed, notreviewed }

class ReviewTask {
  final int taskNumber;
  final IconData? icon;
  final String taskName;
  final TaskStatus status;

  ReviewTask({
    required this.taskNumber,
    this.icon,
    required this.taskName,
    required this.status,
  });
}
