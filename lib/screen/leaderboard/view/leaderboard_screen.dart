import 'dart:ui';
import 'package:ammentor/screen/leaderboard/provider/leaderboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/leaderboard_tile.dart';
import 'package:flutter/services.dart';
import 'package:ammentor/screen/leaderboard/model/leaderboard_model.dart';

var overallTrack = Track(id: -1, title: 'Overall');

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
                  final fullTrackList = [overallTrack, ...trackList];

                  if (selectedTrack == null && trackList.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(selectedTrackProvider.notifier).state = trackList.first;
                    });
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.white.withOpacity(0.06)),
                              ),
                              child: SizedBox(
                                height: 42,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: fullTrackList.length,
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  itemBuilder: (context, index) {
                                    final track = fullTrackList[index];
                                    final isSelected = selectedTrack?.id == track.id;

                                    return GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        ref.read(selectedTrackProvider.notifier).state = track;
                                      },
                                      child: AnimatedScale(
                                        scale: isSelected ? 1.0 : 0.95,
                                        duration: const Duration(milliseconds: 250),
                                        curve: Curves.easeOut,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 220),
                                          curve: Curves.easeInOut,
                                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                          margin: const EdgeInsets.symmetric(horizontal: 6),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primary.withOpacity(0.12)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: AppColors.primary.withOpacity(0.15),
                                                      blurRadius: 6,
                                                      spreadRadius: 0.4,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ]
                                                : [],
                                          ),
                                          child: Text(
                                            track.title,
                                            style: AppTextStyles.caption(context).copyWith(
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : Colors.white.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          left: 20,
                          right: 20,
                          child: Container(
                            height: 2.5,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.01),
              if (selectedTrack != null)
                ref.watch(
                  selectedTrack.id == -1
                    ? overallLeaderboardProvider
                    : leaderboardProvider(selectedTrack.id)
                ).when(
                  loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
                  error: (e, _) => Expanded(child: Center(child: Text("Error: $e"))),
                  data: (users) => Expanded(
                    child: users.isEmpty
                        ? const Center(child: Text("No data available."))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.01,
                                vertical: screenHeight * 0.01),
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
                                      onTap: () {},
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