import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/track/model/track_model.dart';

class TaskTile extends StatefulWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isCompleted = widget.task.isCompleted;

    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.008),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(18),
          splashColor: Colors.white.withOpacity(0.06),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.03),
                  Colors.white.withOpacity(0.015),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white12, width: 0.7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.018),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: w * 0.1,
                  height: w * 0.1,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.white
                        : AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.task.taskNumber}',
                    style: AppTextStyles.body(context).copyWith(
                      color: isCompleted ? Colors.black : AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(width: w * 0.04),
                Expanded(
                  child: Text(
                    widget.task.taskName,
                    style: AppTextStyles.subheading(context).copyWith(
                      color: isCompleted ? Colors.black : AppColors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: w * 0.02),
                Text(
                  '${widget.task.points} pts',
                  style: AppTextStyles.body(context).copyWith(
                    color: isCompleted ? Colors.black : Colors.grey[400],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}