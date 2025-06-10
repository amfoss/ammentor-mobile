import 'package:flutter/material.dart';

enum TaskStatus { reviewed, notreviewed }

class ReviewTask {
  final int taskNumber;
  final String taskName;
  final dynamic icon; // keep as dynamic or remove if not needed
  final TaskStatus status;

  ReviewTask({
    required this.taskNumber,
    required this.taskName,
    this.icon,
    required this.status,
  });

  factory ReviewTask.fromJson(Map<String, dynamic> json) {
    return ReviewTask(
      taskNumber: json['task_no'] ?? 0,
      taskName: json['title'] ?? '',
      icon: json['icon'], // or null if not present
      status: _parseStatus(json['status']),
    );
  }
}

TaskStatus _parseStatus(dynamic status) {
  if (status == null) return TaskStatus.notreviewed;
  final s = status.toString().toLowerCase();
  if (s == 'reviewed' || s == 'approved') return TaskStatus.reviewed;
  return TaskStatus.notreviewed;
}
