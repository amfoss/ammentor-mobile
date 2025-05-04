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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Text(
              '$number',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
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
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                mentee.name,
                style: const TextStyle(color: AppColors.white, fontSize: 18),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
