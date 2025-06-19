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

    // Load tracks and select the first one before fetching tasks
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Do nothing — logic moved to initState to prevent race condition
  }

  @override
  Widget build(BuildContext context) {
  final activeFilter = ref.watch(menteeTaskFilterProvider);
  final tracksAsync = ref.watch(tracksProvider);
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
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.018),
        child: Column(
          children: [
            // Filter buttons and dropdown
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Pending button
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(menteeTaskFilterProvider.notifier).state = 'pending';
                        _refreshTasks();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        backgroundColor: activeFilter == 'pending'
                            ? AppColors.primary
                            : AppColors.surface,
                        foregroundColor: activeFilter == 'pending'
                            ? Colors.black
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (activeFilter == 'pending')
                            const Icon(Icons.check, color: Colors.black, size: 16),
                          const SizedBox(width: 4),
                          const Text('Pending', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Returned button
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(menteeTaskFilterProvider.notifier).state = 'returned';
                        _refreshTasks();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        backgroundColor: activeFilter == 'returned'
                            ? AppColors.primary
                            : AppColors.surface,
                        foregroundColor: activeFilter == 'returned'
                            ? Colors.black
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (activeFilter == 'returned')
                            const Icon(Icons.check, color: Colors.black, size: 16),
                          const SizedBox(width: 4),
                          const Text('Returned', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Track Dropdown
                  tracksAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (_, __) => const Text("Error"),
                    data: (trackList) {
                      return Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Track>(
                            value: selectedTrack,
                            dropdownColor: AppColors.surface,
                            style: AppTextStyles.input(context),
                            iconEnabledColor: Colors.white,
                            onChanged: (Track? newTrack) {
                              if (newTrack != null) {
                                setState(() {
                                  selectedTrack = newTrack;
                                });
                                _refreshTasks();
                              }
                            },
                            items: trackList.map<DropdownMenuItem<Track>>((Track track) {
                              return DropdownMenuItem<Track>(
                                value: track,
                                child: Text(
                                  track.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(
              height: screenHeight * 0.04,
              child: const Divider(color: AppColors.grey, thickness: 1.0),
            ),

            // Task list
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
                    separatorBuilder: (context, index) =>
                        SizedBox(height: screenHeight * 0.018),
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
                error: (err, stack) => Center(
                  child: Text('Failed to load tasks',
                      style: AppTextStyles.caption(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final menteeTaskFilterProvider = StateProvider<String>((ref) => 'pending');