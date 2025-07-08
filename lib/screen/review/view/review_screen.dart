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

  void _showTrackSelector(BuildContext context, WidgetRef ref) {
    final trackList = ref.read(tracksProvider).maybeWhen(
      data: (list) => list,
      orElse: () => [],
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.95),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var track in trackList)
              ListTile(
                title: Text(
                  track.name,
                  style: AppTextStyles.body(context).copyWith(color: Colors.white),
                ),
                onTap: () {
                  ref.read(selectedTrackProvider.notifier).state = track.id;
                  ref.read(taskReviewControllerProvider.notifier).fetchTasksForTrack(track.id);
                  Navigator.pop(context);
                },
              ),
            const Divider(color: Colors.white10),
            ListTile(
              title: Center(
                child: Text(
                  'Cancel',
                  style: AppTextStyles.body(context).copyWith(color: Colors.redAccent),
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

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
          'Submit-Task',
          style: AppTextStyles.subheading(context).copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.018),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.015,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.035),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(activeTaskFilterProvider.notifier).state = 'handin';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeFilter == 'handin'
                          ? AppColors.primary.withOpacity(0.12)
                          : Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text(
                      'Hand in',
                      style: AppTextStyles.caption(context).copyWith(
                        color: activeFilter == 'handin'
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(activeTaskFilterProvider.notifier).state = 'submissions';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeFilter == 'submissions'
                          ? AppColors.primary.withOpacity(0.12)
                          : Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text(
                      'Submissions',
                      style: AppTextStyles.caption(context).copyWith(
                        color: activeFilter == 'submissions'
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  GestureDetector(
                    onTap: () => _showTrackSelector(context, ref),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Text(
                        tracks.when(
                          data: (list) {
                            final selected = list.firstWhere(
                              (t) => t.id == selectedTrackId,
                              orElse: () => list[0],
                            );
                            return selected.name;
                          },
                          loading: () => 'Loading...',
                          error: (_, __) => 'Error',
                        ),
                        style: AppTextStyles.caption(context).copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.025),

            Expanded(
              child: taskList.isEmpty
                  ? const Center(child: Text("No data found."))
                  : ListView.separated(
                      itemCount: taskList.length,
                      separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.018),
                      itemBuilder: (_, index) {
                        final item = taskList[index];

                        if (activeFilter == 'handin' && item is ReviewTask) {
                          return ReviewTaskTile(task: item);
                        } else if (activeFilter == 'submissions' && item is Submission) {
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