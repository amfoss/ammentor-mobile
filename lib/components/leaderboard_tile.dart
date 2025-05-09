import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color:
              isCurrentUser
                  ? AppColors.primary.withOpacity(0.2)
                  : AppColors.cardBackground,
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
              style:  AppTextStyles.body(context).copyWith(
                fontWeight: FontWeight.bold,

              ),
            ),
            SizedBox(width: screenWidth * 0.03) ,
            CircleAvatar(radius: 25, backgroundImage: NetworkImage(avatarUrl)),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.body(context).copyWith(color: AppColors.white),
              ),
            ),
            Text(
              '$points pts',
              style: AppTextStyles.caption(context).copyWith(
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
