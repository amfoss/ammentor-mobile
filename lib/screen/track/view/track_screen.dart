import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/track/provider/track_provider.dart';
import 'package:ammentor/components/task_tile.dart';

class TrackScreen extends ConsumerStatefulWidget {
  const TrackScreen({super.key});

  @override
  ConsumerState<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends ConsumerState<TrackScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _topContainerValue = 0;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _topContainerValue = _scrollController.offset / 120;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTrack = ref.watch(selectedTrackProvider);
    final currentTasks = ref.watch(currentTrackTasksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tracks', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return Column(
            children: [
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: availableTracks.length,
                  itemBuilder: (context, index) {
                    final track = availableTracks[index];
                    final isSelected = selectedTrack == track;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(track),
                        selected: isSelected,
                        onSelected: (_) {
                          ref.read(selectedTrackProvider.notifier).state =
                              track;
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  itemCount: currentTasks.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = currentTasks[index];
                    final scale =
                        (_topContainerValue > index)
                            ? (1 - (_topContainerValue - index)).clamp(0.7, 1.0)
                            : 1.0;

                    return FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          parent: _animationController!,
                          curve: Interval(
                            index * 0.05,
                            1.0,
                            curve: Curves.easeIn,
                          ),
                        ),
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.2),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController!,
                            curve: Interval(
                              index * 0.05,
                              1.0,
                              curve: Curves.easeIn,
                            ),
                          ),
                        ),
                        child: Transform.scale(
                          scale: scale,
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TaskTile(taskName: task, onTap: () {}),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
