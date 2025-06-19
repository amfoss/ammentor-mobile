import 'package:ammentor/components/submission_tile.dart';
import 'package:ammentor/screen/review/model/review_model.dart';
import 'package:ammentor/screen/review/model/submission_model.dart';
import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/review_task_tile.dart';
import 'package:ammentor/screen/review/provider/review_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskReviewScreen extends ConsumerWidget {
  TaskReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(taskReviewControllerProvider.notifier);
    final activeFilter = ref.watch(activeTaskFilterProvider);
    final tracks = ref.watch(tracksProvider);
    final selectedTrackId = ref.watch(selectedTrackProvider);
    final taskList = ref.watch(taskReviewControllerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Submit Task',
          style: AppTextStyles.subheading(
            context,
          ).copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.018),
        child: Column(
          children: [
            // ===== Filter Buttons and Dropdown ===== //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hand in Button
                ElevatedButton(
                  onPressed: () {
                    ref.read(activeTaskFilterProvider.notifier).state =
                        'handin';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        activeFilter == 'handin'
                            ? AppColors.primary
                            : AppColors.surface,
                    foregroundColor:
                        activeFilter == 'handin' ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (activeFilter == 'handin')
                        const Icon(Icons.check, color: Colors.black),
                      SizedBox(width: screenWidth * 0.01),
                      const Text('Hand in'),
                    ],
                  ),
                ),

                SizedBox(width: screenWidth * 0.02),

                // Submissions Button
                ElevatedButton(
                  onPressed: () {
                    ref.read(activeTaskFilterProvider.notifier).state =
                        'submissions';
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        activeFilter == 'submissions'
                            ? AppColors.primary
                            : AppColors.surface,
                    foregroundColor:
                        activeFilter == 'submissions'
                            ? Colors.black
                            : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (activeFilter == 'submissions')
                        const Icon(Icons.check, color: Colors.black),
                      SizedBox(width: screenWidth * 0.01),
                      const Text('Submissions'),
                    ],
                  ),
                ),

                SizedBox(width: screenWidth * 0.02),

                // Track Dropdown
                tracks.when(
                  data:
                      (trackList) => DropdownButton<String>(
                        value: selectedTrackId,
                        items:
                            trackList.map((track) {
                              return DropdownMenuItem<String>(
                                value: track.id,
                                child: Text(track.name),
                              );
                            }).toList(),
                        onChanged: (selectedTrackId) {
                          ref.read(selectedTrackProvider.notifier).state =
                              selectedTrackId;
                          controller.fetchTasksForTrack(selectedTrackId!);
                        },
                        hint: const Text('Select Track'),
                      ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error loading tracks'),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.04,
              child: Divider(color: AppColors.grey, thickness: 1.0),
            ),

            // Task or Submission List
            Expanded(
              child:
                  taskList.isEmpty
                      ? const Center(child: Text("No data found."))
                      : ListView.separated(
                        itemCount: taskList.length,
                        separatorBuilder:
                            (_, __) => SizedBox(height: screenHeight * 0.018),
                        itemBuilder: (_, index) {
                          final item = taskList[index];

                          if (activeFilter == 'handin' && item is ReviewTask) {
                            return ReviewTaskTile(task: item);
                          } else if (activeFilter == 'submissions' &&
                              item is Submission) {
                            return SubmissionTile(submission: item);
                          }

                          return const SizedBox();
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
