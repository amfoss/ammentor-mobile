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
    final tracks = ref.watch(tracksProvider); // Fetch tracks from backend
    final selectedTrack = ref.watch(selectedTrackProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Submit Task',
          style: AppTextStyles.subheading(context).copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.018),
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
                       SizedBox(width: screenWidth * 0.01),
                      const Text('Hand in'),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
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
                       SizedBox(width:screenWidth * 0.01),
                      const Text('Submissions'),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                tracks.when(
                  data: (trackList) => DropdownButton<String>(
                    value: selectedTrack,
                    items: trackList.map((track) {
                      return DropdownMenuItem<String>(
                        value: track.id, // Use track ID (String) for selection
                        child: Text(track.name), // Display track name
                      );
                    }).toList(),
                    onChanged: (selectedTrackId) {
                      ref.read(selectedTrackProvider.notifier).state = selectedTrackId;
                    },
                    hint: const Text('Select Track'),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => const Text('Error loading tracks'),
                ),
              ],
            ),
             SizedBox(height: screenHeight * 0.04,
              child: Divider(
                color: AppColors.grey,
                thickness: 1.0,
              ),),
            Expanded(
              child: ListView.separated(
                itemCount: taskList.length,
                separatorBuilder:
                    (context, index) =>  SizedBox(height: screenHeight * 0.018),
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
final selectedTrackProvider = StateProvider<String?>((ref) => null);
