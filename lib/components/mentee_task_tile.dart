import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/mentor-evaluation/view/evaluation_screen_pending_tasks.dart';
import 'package:ammentor/screen/mentor-evaluation/view/evaluation_screen_returned_tasks.dart';
import 'package:ammentor/screen/mentor-evaluation/model/mentee_tasks_model.dart';

class TaskTile extends ConsumerWidget {
  final Task task;
  final VoidCallback? onTaskEvaluated;
  final String? menteeEmail;
  final int trackId;

  const TaskTile({
    super.key,
    required this.task,
    this.onTaskEvaluated,
    this.menteeEmail,
    required this.trackId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(top: h * 0.005, bottom: h * 0.005),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.white.withOpacity(0.05),
        onTap: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) =>
                      task.status == TaskStatus.returned
                          ? TaskEvaluationViewScreen(
                            task: task,
                            menteeEmail: menteeEmail ?? "",
                            onTaskEvaluated: onTaskEvaluated,
                            trackId: trackId,
                          )
                          : TaskEvaluationScreen(
                            task: task,
                            onEvaluated: onTaskEvaluated,
                          ),
            ),
          );
          if (result == true && onTaskEvaluated != null) {
            onTaskEvaluated!();
          }
        },
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: h * 0.018,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.025),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: w * 0.1,
                height: w * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 1),
                ),
                child: Text(
                  '${task.taskNumber}',
                  style: AppTextStyles.body(context).copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(width: w * 0.04),
              Expanded(
                child: Text(
                  task.taskName,
                  style: AppTextStyles.subheading(context).copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: w * 0.02),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.white.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
