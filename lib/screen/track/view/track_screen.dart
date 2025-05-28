import 'package:ammentor/screen/track/model/track_model.dart';
import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/track_tile.dart';
import 'package:ammentor/components/task_tile.dart';
import 'package:ammentor/screen/track/provider/track_provider.dart';

class TracksScreen extends ConsumerWidget {
  const TracksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(tracksProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tracks', style: AppTextStyles.subheading(context).copyWith(color: AppColors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: tracksAsync.when(
          data: (tracks) {
            return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return TrackTile(
                  track: track,
                  onTrackTap: (selectedTrack) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TasksScreen(track: selectedTrack),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

class TasksScreen extends ConsumerWidget {
  final Track track;
  const TasksScreen({super.key, required this.track});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider(track.id));
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(track.title, style: AppTextStyles.body(context).copyWith(color: AppColors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: tasksAsync.when(
          data: (tasks) {
            return ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (context, index) => SizedBox(height: screenHeight * 0.01),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskTile(task: task);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
