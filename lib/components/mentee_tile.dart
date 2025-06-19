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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.009),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: height * 0.04,
              height: height * 0.04,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
              alignment: Alignment.center,
              child: Text(
                '$number',
                style: AppTextStyles.caption(context).copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ),
            SizedBox(width: width * 0.04),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.transparent,
              backgroundImage: mentee.imageUrl != null
                  ? NetworkImage(mentee.imageUrl!)
                  : null,
              child: mentee.imageUrl == null
                  ? Icon(Icons.person, size: 22, color: Colors.white.withOpacity(0.6))
                  : null,
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Text(
                mentee.name,
                style: AppTextStyles.caption(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
            ),
            Text(
              '${mentee.totalPoints} pts',
              style: AppTextStyles.caption(context).copyWith(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}