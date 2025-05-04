import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/review_task_tile.dart';
import 'package:ammentor/screen/review/provider/review_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskReviewScreen extends ConsumerWidget {
  const TaskReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskList = ref.watch(taskReviewControllerProvider);
    final controller = ref.read(taskReviewControllerProvider.notifier);
    final activeFilter = ref.watch(activeTaskFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Task review',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.filterTasks('notreviewed');
                    ref.read(activeTaskFilterProvider.notifier).state =
                        'notreviewed';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        activeFilter == 'notreviewed'
                            ? AppColors.primary
                            : AppColors.surface,
                    foregroundColor:
                        activeFilter == 'notreviewed'
                            ? Colors.black
                            : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (activeFilter == 'notreviewed')
                        const Icon(Icons.check, color: Colors.black),
                      const SizedBox(width: 8.0),
                      const Text('Hand in'),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    controller.filterTasks('reviewed');
                    ref.read(activeTaskFilterProvider.notifier).state =
                        'reviewed';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        activeFilter == 'reviewed'
                            ? AppColors.primary
                            : AppColors.surface,
                    foregroundColor:
                        activeFilter == 'reviewed'
                            ? Colors.black
                            : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (activeFilter == 'reviewed')
                        const Icon(Icons.check, color: Colors.black),
                      if (activeFilter == 'reviewed')
                        const SizedBox(width: 8.0),
                      const Text('Reviewed'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.separated(
                itemCount: taskList.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  final task = taskList[index];
                  return ReviewTaskTile(task: task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final activeTaskFilterProvider = StateProvider<String>((ref) => 'notreviewed');
