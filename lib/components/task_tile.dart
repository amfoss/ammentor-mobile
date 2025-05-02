import 'package:ammentor/screen/track/model/track_model.dart';
import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: task.isCompleted ? AppColors.primary : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              '${task.taskNumber}',
              style: TextStyle(
                color: task.isCompleted ? Colors.black : AppColors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            task.icon,
            color: task.isCompleted ? Colors.black : AppColors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.taskName,
              style: TextStyle(
                color: task.isCompleted ? Colors.black : AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${task.points} Points',
            style: TextStyle(
              color: task.isCompleted ? Colors.black : Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
