import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/evaluation/model/mentee_list_model.dart';

class MenteeTile extends StatelessWidget {
  final int number;
  final Mentee mentee;
  final VoidCallback? onTap;

  const MenteeTile({
    super.key,
    required this.number,
    required this.mentee,
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
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Text(
              '$number',
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            CircleAvatar(
              radius: 25,
              backgroundImage:
                  mentee.imageUrl != null
                      ? NetworkImage(mentee.imageUrl!)
                      : null,
              child:
                  mentee.imageUrl == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                mentee.name,
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${mentee.totalPoints} pts',
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
          ],
        ),
      ),
    );
  }
}
