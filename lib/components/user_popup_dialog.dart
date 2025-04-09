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
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
            radius: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Rank: #$rank', style: const TextStyle(color: AppColors.white)),
          const SizedBox(height: 8),
          Text('Points: $points', style: const TextStyle(color: AppColors.white)),
          const SizedBox(height: 8),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque non erat nec nisi facilisis facilisis.',
            style: const TextStyle(color: AppColors.white),
          ),
          const SizedBox(height: 8),
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
          child: const Text('Close', style: TextStyle(color: AppColors.primary)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}