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
    final tracksAsyncValue = ref.watch(tracksProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tracks',
            style: AppTextStyles.subheading(context).copyWith(color: AppColors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: tracksAsyncValue.when(
        data: (tracks) {
          if (tracks.isEmpty) {
            return const Center(child: Text('No tracks available.', style: TextStyle(color: AppColors.white)));
          }
          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.01),
            child: ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return TrackTile(
                  showImage: false,
                  track: track,
                  onTrackTap: (selectedTrack) async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    try {
                      await ref.read(tracksProvider.notifier).fetchTasksForTrack(selectedTrack.id);
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => TasksScreen(track: selectedTrack),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to load tasks: $e')),
                        );
                      }
                    }
                  },
                );
              },
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (err, stack) {
          return Center(child: Text('Error: $err', style: TextStyle(color: AppColors.white)));
        },
      ),
    );
  }
}

class TasksScreen extends ConsumerWidget {
  final Track track;
  const TasksScreen({super.key, required this.track});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsyncValue = ref.watch(tracksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(track.name,
            style: AppTextStyles.body(context).copyWith(color: AppColors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: tracksAsyncValue.when(
        data: (allTracks) {
          final currentTrackWithTasks = allTracks.firstWhere(
            (t) => t.id == track.id,
            orElse: () {
              return track;
            },
          );

          final tasks = currentTrackWithTasks.tasks;

          if (tasks.isEmpty) {
            return const Center(
              child: Text('No tasks found for this track.', style: TextStyle(color: AppColors.white)),
            );
          }

          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.01),
            child: ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: screenHeight * 0.01),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskTile(task: task);
              },
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (err, stack) {
          return Center(child: Text('Error: $err', style: TextStyle(color: AppColors.white)));
        },
      ),
    );
  }
}
