import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';

class LeaderboardTile extends StatefulWidget {
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
  State<LeaderboardTile> createState() => _LeaderboardTileState();
}

class _LeaderboardTileState extends State<LeaderboardTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;
  late Animation<double> _opacity;

  Color? _getGlowColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amberAccent.withOpacity(0.3);
      case 2:
        return Colors.grey.withOpacity(0.25);
      case 3:
        return Colors.brown.withOpacity(0.2);
      default:
        return null;
    }
  }

  IconData? _getRankIcon(int rank) {
    if (rank <= 3) return Icons.emoji_events_rounded;
    return null;
  }

  Color _getRankIconColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amberAccent;
      case 2:
        return Colors.grey[300]!;
      case 3:
        return Colors.brown[300]!;
      default:
        return AppColors.white.withOpacity(0.85);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500 + widget.rank * 30),
      vsync: this,
    );

    _offset = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = _getGlowColor(widget.rank);
    final iconData = _getRankIcon(widget.rank);
    final iconColor = _getRankIconColor(widget.rank);
    final screenWidth = MediaQuery.of(context).size.width;

    return SlideTransition(
      position: _offset,
      child: FadeTransition(
        opacity: _opacity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onTap,
              splashColor: Colors.white.withOpacity(0.08),
              highlightColor: Colors.white.withOpacity(0.04),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: widget.isCurrentUser
                          ? AppColors.primary.withOpacity(0.15)
                          : Colors.white.withOpacity(0.035),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.isCurrentUser
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.06),
                        width: 1.2,
                      ),
                      boxShadow: [
                        if (glowColor != null)
                          BoxShadow(
                            color: glowColor,
                            blurRadius: 30,
                            spreadRadius: 1,
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (iconData != null) ...[
                          Icon(iconData, color: iconColor, size: 22),
                          const SizedBox(width: 6),
                        ] else ...[
                          Text(
                            '#${widget.rank}',
                            style: AppTextStyles.body(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: widget.isCurrentUser
                                  ? AppColors.primary
                                  : Colors.white.withOpacity(0.95),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                        ],
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(widget.avatarUrl),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: Text(
                            widget.name,
                            style: AppTextStyles.body(context).copyWith(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${widget.points} pts',
                          style: AppTextStyles.caption(context).copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}