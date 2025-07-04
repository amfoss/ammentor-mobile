import 'package:flutter/material.dart';

enum TaskStatus { approved, paused, submitted }

class ReviewTask {
  final int taskNumber;
  final String taskName;
  final TaskStatus status;
  final int trackId;

  ReviewTask({
    required this.taskNumber,
    required this.taskName,
    required this.trackId,
    required this.status,

  });

  factory ReviewTask.fromJson(Map<String, dynamic> json) {
    final statusStr = (json['status'] ?? '').toString().toLowerCase();
    TaskStatus status = TaskStatus.submitted;

    if (statusStr == 'approved') {
      status = TaskStatus.approved;
    } else if (statusStr == 'paused') {
      status = TaskStatus.paused;
    }

    return ReviewTask(
      trackId: json['track_id'] ?? 0,
      taskNumber: json['task_no'] ?? 0,
      taskName: json['title']?.toString() ?? 'Untitled',
      status: status,
    );
  }
}
