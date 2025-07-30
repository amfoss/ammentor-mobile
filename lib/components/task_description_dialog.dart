import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';

class TaskDescriptionDialog extends StatelessWidget {
  final String title;
  final String description;
  final int points;
  final int? deadline;

  const TaskDescriptionDialog({
    super.key,
    required this.title,
    required this.description,
    required this.points,
    this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.97),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.background.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.035),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.heading(context).copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: h * 0.028,
              ),
            ),
            SizedBox(height: h * 0.012),
            Divider(color: AppColors.primary.withOpacity(0.3), thickness: 1.2),
            SizedBox(height: h * 0.012),
            Text(
              description,
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.white.withOpacity(0.95),
                fontSize: h * 0.021,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            SizedBox(height: h * 0.025),
            Row(
              children: [
                Icon(Icons.star, color: AppColors.primary, size: 22),
                SizedBox(width: w * 0.015),
                Text(
                  '$points pts',
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (deadline != null) ...[
                  SizedBox(width: w * 0.04),
                  Icon(Icons.timer_outlined, color: AppColors.white70, size: 20),
                  SizedBox(width: w * 0.01),
                  Text(
                    'Deadline: $deadline days',
                    style: AppTextStyles.caption(context).copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: h * 0.018),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: AppTextStyles.button(context).copyWith(fontWeight: FontWeight.w600),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
