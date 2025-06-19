import 'package:ammentor/screen/leaderboard/provider/leaderboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/user_popup_dialog.dart';
import 'package:ammentor/components/leaderboard_tile.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Leaderboard',
          style: AppTextStyles.subheading(context).copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              ref.watch(trackListProvider).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
                data: (trackList) {
                  if (selectedTrack == null && trackList.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(selectedTrackProvider.notifier).state = trackList[0];
                    });
                  }

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
                            label: Text(track.title),
                            selected: isSelected,
                            onSelected: (_) {
                              ref.read(selectedTrackProvider.notifier).state = track;
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.01),
              if (selectedTrack != null)
                ref.watch(leaderboardProvider(selectedTrack.id)).when(
                  loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
                  error: (e, _) => Expanded(child: Center(child: Text("Error: $e"))),
                  data: (users) => Expanded(
                    child: users.isEmpty
                        ? const Center(child: Text("No data available."))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.01),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final scale = (_topContainerValue > index)
                                  ? (1 - (_topContainerValue - index)).clamp(0.7, 1.0)
                                  : 1.0;

                              return FadeTransition(
                                opacity: Tween<double>(begin: 0, end: 1).animate(
                                  CurvedAnimation(
                                    parent: _animationController!,
                                    curve: Interval(index * 0.05, 1.0, curve: Curves.easeIn),
                                  ),
                                ),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.2),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController!,
                                      curve: Interval(index * 0.05, 1.0, curve: Curves.easeIn),
                                    ),
                                  ),
                                  child: Transform.scale(
                                    scale: scale,
                                    alignment: Alignment.center,
                                    child: LeaderboardTile(
                                      rank: index + 1,
                                      name: user.name,
                                      avatarUrl: user.avatarUrl,
                                      points: user.allTimePoints,
                                      isCurrentUser: false,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => UserPopupDialog(
                                            name: user.name,
                                            avatarUrl: user.avatarUrl,
                                            rank: index + 1,
                                            points: user.allTimePoints,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}