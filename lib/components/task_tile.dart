import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';

class TaskTile extends StatelessWidget {
  final String taskName;
  final VoidCallback onTap;

  const TaskTile({Key? key, required this.taskName, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  taskName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
