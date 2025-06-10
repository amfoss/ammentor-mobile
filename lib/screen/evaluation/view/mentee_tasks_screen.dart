import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/mentee_task_tile.dart';
import 'package:ammentor/screen/evaluation/model/mentee_list_model.dart';
import 'package:ammentor/screen/evaluation/model/mentee_tasks_model.dart';
import 'package:ammentor/screen/evaluation/provider/mentee_tasks_provider.dart';

class MenteeTasksScreen extends ConsumerStatefulWidget {
  final Mentee mentee;

  const MenteeTasksScreen({super.key, required this.mentee});

  @override
  ConsumerState<MenteeTasksScreen> createState() => _MenteeTasksScreenState();
}

class _MenteeTasksScreenState extends ConsumerState<MenteeTasksScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Invalidate the provider so it always fetches fresh data when this screen is shown
    final activeFilter = ref.read(menteeTaskFilterProvider);
    ref.invalidate(menteeTasksControllerProvider('${widget.mentee.id}-$activeFilter'));
  }

  @override
  Widget build(BuildContext context) {
    final activeFilter = ref.watch(menteeTaskFilterProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final tasksAsync = ref.watch(menteeTasksControllerProvider('${widget.mentee.id}-$activeFilter'));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.mentee.name,
          style:  AppTextStyles.subheading(context).copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.018),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(menteeTaskFilterProvider.notifier).state = 'pending';
                    ref.invalidate(menteeTasksControllerProvider('${widget.mentee.id}-pending'));
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
                      SizedBox(width: screenWidth * 0.02),
                      const Text('Pending'),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                ElevatedButton(
                  onPressed: () {
                    ref.read(menteeTaskFilterProvider.notifier).state = 'returned';
                    ref.invalidate(menteeTasksControllerProvider('${widget.mentee.id}-returned'));
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
                        SizedBox(width: screenWidth * 0.02),
                      const Text('Returned'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04,
                child: Divider(
                color: AppColors.grey,
                thickness: 1.0,
              ),),
            Expanded(
              child: tasksAsync.when(
                data: (taskList) {
                  if (taskList.isEmpty) {
                    return Center(child: Text('No tasks found', style: AppTextStyles.caption(context)));
                  }
                  return ListView.separated(
                    itemCount: taskList.length,
                    separatorBuilder:
                        (context, index) => SizedBox(height: screenHeight * 0.018),
                    itemBuilder: (context, index) {
                      final task = taskList[index];
                      return TaskTile(task: task);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Failed to load tasks', style: AppTextStyles.caption(context))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final menteeTaskFilterProvider = StateProvider<String>((ref) => 'pending');
