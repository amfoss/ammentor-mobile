import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';

class UserPopupDialog extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final int rank;
  final int points;

  const UserPopupDialog({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.rank,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
            radius: 30,
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Rank: #$rank', style: AppTextStyles.caption(context).copyWith(color: AppColors.white)),
          SizedBox(height: screenHeight * 0.01),
          Text('Points: $points', style: AppTextStyles.caption(context).copyWith(color: AppColors.white)),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque non erat nec nisi facilisis facilisis.',
             style: AppTextStyles.caption(context).copyWith(color: AppColors.white)
          ),
           SizedBox(height: screenHeight * 0.01),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //     },
          //     child: const Text('Close'),
          //     ),
              
        ],
      ),
      actions: [
        TextButton(
          child: Text('Close', style: AppTextStyles.button(context).copyWith(color: AppColors.primary)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}