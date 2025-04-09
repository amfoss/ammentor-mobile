import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/user_popup_dialog.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _topContainerValue = 0;
  AnimationController? _animationController;
  bool _isWeeklySelected = true;

  final List<Map<String, dynamic>> users = List.generate(
    40,
    (index) => {
      'name': 'User $index',
      'avatar': 'https://robohash.org/User$index.png',
      'weeklyPoints': (10 - index) * 20,
      'allTimePoints': (10 - index) * 10,
    },
  );

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(color: AppColors.white),
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
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Weekly'),
                    selected: _isWeeklySelected,
                    onSelected: (selected) {
                      setState(() => _isWeeklySelected = true);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('All-Time'),
                    selected: !_isWeeklySelected,
                    onSelected: (selected) {
                      setState(() => _isWeeklySelected = false);
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                            name: user['name'],
                            avatarUrl: user['avatar'],
                            points: _isWeeklySelected ? user['weeklyPoints'] : user['allTimePoints'],
                            isCurrentUser: index == 2,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => UserPopupDialog(
                                  name: user['name'],
                                  avatarUrl: user['avatar'],
                                  rank: index + 1,
                                  points: _isWeeklySelected ? user['weeklyPoints'] : user['allTimePoints'],
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
            ],
          );
        },
      ),
    );
  }
}

class LeaderboardTile extends StatelessWidget {
  final int rank;
  final String name;
  final String avatarUrl;
  final int points;
  final bool isCurrentUser;
  final VoidCallback? onTap;

  const LeaderboardTile({
    super.key,
    required this.rank,
    required this.name,
    required this.avatarUrl,
    required this.points,
    this.isCurrentUser = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.primary.withOpacity(0.2) : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCurrentUser ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(
              '$rank',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              '$points pts',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}