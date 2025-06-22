import 'package:ammentor/screen/track/model/track_model.dart';
import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final void Function(Track) onTrackTap;

  /// Control flags for optional UI
  final bool showDescription;
  final bool showProgress;
  final bool showImage;

  const TrackTile({
    super.key,
    required this.track,
    required this.onTrackTap,
    this.showDescription = true,
    this.showProgress = true,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => onTrackTap(track),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            if (showImage)
              SizedBox(
                width: screenWidth * 0.15,
                height: screenHeight * 0.08,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    track.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Text('No Image')),
                      );
                    },
                  ),
                ),
              ),
            if (showImage) SizedBox(width: screenWidth * 0.05),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name,
                    style: AppTextStyles.subheading(context).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (showDescription) SizedBox(height: screenHeight * 0.01),
                  if (showDescription)
                    Text(
                      track.description,
                      style: AppTextStyles.subheading(context).copyWith(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  if (showProgress) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: track.progress / 100,
                      backgroundColor: Colors.grey[700],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${track.progress.toInt()}% Complete',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
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