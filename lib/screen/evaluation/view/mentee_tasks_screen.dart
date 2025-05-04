import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/mentee_task_tile.dart';
import 'package:ammentor/screen/evaluation/model/mentee_list_model.dart';
import 'package:ammentor/screen/evaluation/model/mentee_tasks_model.dart';
import 'package:ammentor/screen/evaluation/provider/mentee_tasks_provider.dart';

class MenteeTasksScreen extends ConsumerWidget {
  final Mentee mentee;

  const MenteeTasksScreen({super.key, required this.mentee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskList = ref.watch(menteeTasksControllerProvider(mentee.id));
    final activeFilter = ref.watch(menteeTaskFilterProvider);
    final controller = ref.read(
      menteeTasksControllerProvider(mentee.id).notifier,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          mentee.name,
          style: const TextStyle(color: AppColors.white),
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
                    controller.filterTasks(TaskStatus.pending);
                    ref.read(menteeTaskFilterProvider.notifier).state =
                        'pending';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        activeFilter == 'pending'
                            ? AppColors.primary
                            : AppColors.surface,
                    foregroundColor:
                        activeFilter == 'pending' ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (activeFilter == 'pending')
                        const Icon(Icons.check, color: Colors.black),
                      const SizedBox(width: 8.0),
                      const Text('Pending'),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    controller.filterTasks(TaskStatus.returned);
                    ref.read(menteeTaskFilterProvider.notifier).state =
                        'returned';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        activeFilter == 'returned'
                            ? AppColors.primary
                            : AppColors.surface,
                    foregroundColor:
                        activeFilter == 'returned'
                            ? Colors.black
                            : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (activeFilter == 'returned')
                        const Icon(Icons.check, color: Colors.black),
                      if (activeFilter == 'returned')
                        const SizedBox(width: 8.0),
                      const Text('Returned'),
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
                  return TaskTile(task: task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final menteeTaskFilterProvider = StateProvider<String>((ref) => 'pending');
