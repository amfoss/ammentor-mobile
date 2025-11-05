import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/mentee_task_tile.dart';
import 'package:ammentor/screen/mentor-evaluation/model/mentee_list_model.dart';
import 'package:ammentor/screen/mentor-evaluation/provider/mentee_tasks_provider.dart';
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
    final trackId = selectedTrack?.id;
    if (trackId != null) {
      ref.invalidate(menteeTasksControllerProvider((
        email: widget.mentee.id,
        filter: activeFilter,
        trackId: int.parse(trackId),
      )));
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final tracksAsync = ref.read(tracksProvider);
      tracksAsync.whenData((tracks) {
        if (tracks.isNotEmpty) {
          setState(() {
            selectedTrack = tracks[0];
          });
          _refreshTasks();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeFilter = ref.watch(menteeTaskFilterProvider);
    final tracksAsync = ref.watch(tracksProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final trackId = selectedTrack?.id;
    final tasksAsync = trackId != null
        ? ref.watch(menteeTasksControllerProvider((
            email: widget.mentee.id,
            filter: activeFilter,
            trackId: int.parse(trackId),
          )))
        : const AsyncValue.loading();

    tracksAsync.when(
      data: (trackList) {
        if (selectedTrack == null && trackList.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedTrack = trackList[0];
            });
            _refreshTasks();
          });
        }
      },
      loading: () {},
      error: (_, __) {},
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.mentee.name,
          style: AppTextStyles.subheading(context).copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.018),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip("pending", activeFilter, context, screenWidth, screenHeight),
                  SizedBox(width: screenWidth * 0.02),
                  _buildFilterChip("returned", activeFilter, context, screenWidth, screenHeight),
                  SizedBox(width: screenWidth * 0.02),
                  tracksAsync.when(
                    loading: () => SizedBox(
                      width: screenWidth * 0.05,
                      height: screenWidth * 0.05,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => Text("Error", style: AppTextStyles.caption(context)),
                    data: (trackList) {
                      return _buildTrackDropdown(trackList, context, screenWidth, screenHeight);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Divider(color: AppColors.grey, thickness: 1.0),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: tasksAsync.when(
                data: (taskList) {
                  if (taskList.isEmpty) {
                    return Center(
                      child: Text('No tasks submitted', style: AppTextStyles.caption(context)),
                    );
                  }
                  return ListView.separated(
                    itemCount: taskList.length,
                    separatorBuilder: (context, index) => SizedBox(height: screenHeight * 0.018),
                    itemBuilder: (context, index) {
                      final task = taskList[index];
                      return TaskTile(
                        task: task,
                        onTaskEvaluated: _refreshTasks,
                        menteeEmail: widget.mentee.id, trackId: int.parse(selectedTrack!.id),
                        
                      );
                    },
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text('Failed to load tasks', style: AppTextStyles.caption(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String activeFilter, BuildContext context, double w, double h) {
    final isSelected = activeFilter == label;
    return GestureDetector(
      onTap: () {
        ref.read(menteeTaskFilterProvider.notifier).state = label;
        _refreshTasks();
      },
      child: Container(
        height: h * 0.045,
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: Border.all(color: isSelected ? AppColors.primary : Colors.white24),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label[0].toUpperCase() + label.substring(1),
          style: AppTextStyles.caption(context).copyWith(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTrackDropdown(List<Track> trackList, BuildContext context, double w, double h) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: h * 0.025, horizontal: w * 0.05),
              child: Wrap(
                spacing: w * 0.03,
                runSpacing: h * 0.015,
                children: trackList.map((track) {
                  final isSelected = selectedTrack?.id == track.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTrack = track;
                      });
                      Navigator.pop(context);
                      _refreshTasks();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: h * 0.008, horizontal: w * 0.045),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.white24,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        track.name,
                        style: AppTextStyles.caption(context).copyWith(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
      child: Container(
        height: h * 0.045,
        padding: EdgeInsets.symmetric(horizontal: w * 0.035),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedTrack?.name ?? "Select Track",
              style: AppTextStyles.caption(context),
            ),
            SizedBox(width: w * 0.015),
            Icon(Icons.expand_more_rounded, color: Colors.white60, size: 18),
          ],
        ),
      ),
    );
  }
}

final menteeTaskFilterProvider = StateProvider<String>((ref) => 'pending');