import 'package:ammentor/screen/track/model/track_model.dart';
import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final void Function(Track) onTrackTap;

  const TrackTile({super.key, required this.track, required this.onTrackTap});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => onTrackTap(track),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
        padding:  EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.01,
              height: screenHeight * 0.1,
            ),
            SizedBox(width: screenWidth * 0.05),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style:  AppTextStyles.subheading(context).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    track.description,
                    style:  AppTextStyles.subheading(context).copyWith(
                      color: AppColors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  ...[
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
