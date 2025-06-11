import 'package:flutter/material.dart';

enum TaskStatus { approved, paused, submitted }

class ReviewTask {
  final int taskNumber;
  final String taskName;
  final TaskStatus status;
  final IconData? icon;

  ReviewTask({
    required this.taskNumber,
    required this.taskName,
    required this.status,
    required this.icon,
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
      taskNumber: json['task_no'] ?? 0,
      taskName: json['title']?.toString() ?? 'Untitled',
      status: status,
      icon:
          json['icon'] != null
              ? IconData(json['icon'], fontFamily: 'MaterialIcons')
              : null,
    );
  }
}
