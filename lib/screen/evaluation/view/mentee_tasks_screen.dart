import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/mentee_task_tile.dart';
import 'package:ammentor/screen/evaluation/model/mentee_list_model.dart';
import 'package:ammentor/screen/evaluation/provider/mentee_tasks_provider.dart';
import 'package:ammentor/screen/track/provider/track_provider.dart';
import 'package:ammentor/screen/track/model/track_model.dart';

class MenteeTasksScreen extends ConsumerStatefulWidget {
  final Mentee mentee;

  const MenteeTasksScreen({super.key, required this.mentee});

  @override
  ConsumerState<MenteeTasksScreen> createState() => _MenteeTasksScreenState();
}

class _MenteeTasksScreenState extends ConsumerState<MenteeTasksScreen> {
  Track? selectedTrack;

  void _refreshTasks() {
    final activeFilter = ref.read(menteeTaskFilterProvider);
    final trackId = selectedTrack?.id ?? '';
    ref.invalidate(menteeTasksControllerProvider('${widget.mentee.id}-$activeFilter-$trackId'));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tracksAsync = ref.read(tracksProvider);
    tracksAsync.whenData((tracks) {
      if (selectedTrack == null && tracks.isNotEmpty) {
        setState(() {
          selectedTrack = tracks[0];
        });
      }
    });
    _refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    final activeFilter = ref.watch(menteeTaskFilterProvider);
    final tracksAsync = ref.watch(tracksProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final trackId = selectedTrack?.id ?? tracksAsync.maybeWhen(
      data: (tracks) => tracks.isNotEmpty ? tracks[0].id : '',
      orElse: () => '',
    );

    final tasksAsync = ref.watch(menteeTasksControllerProvider('${widget.mentee.id}-$activeFilter-$trackId'));

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
            tracksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (trackList) {
                if (trackList.isEmpty) return const SizedBox.shrink();
                return SizedBox(
                  height: screenHeight * 0.04,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    itemCount: trackList.length,
                    itemBuilder: (context, index) {
                      final track = trackList[index];
                      final isSelected = selectedTrack?.id == track.id;
                      return Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.02),
                        child: ChoiceChip(
                          label: Text(track.name),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedTrack = track;
                            });
                            _refreshTasks();
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(menteeTaskFilterProvider.notifier).state = 'pending';
                    _refreshTasks();
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
                    _refreshTasks();
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
                      return TaskTile(
                        task: task,
                        onTaskEvaluated: _refreshTasks,
                        menteeEmail: widget.mentee.id,
                      );
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
