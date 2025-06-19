import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/track/model/track_model.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final void Function(Track) onTrackTap;
  final bool showDescription;
  final bool showProgress;
  final bool showImage;

  TrackTile({
    super.key,
    required this.track,
    required this.onTrackTap,
    this.showDescription = true,
    this.showProgress = true,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.012,
        horizontal: screenWidth * 0.035,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTrackTap(track),
          splashColor: AppColors.white.withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.04),
                  Colors.white.withOpacity(0.01),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                if (showImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      track.imageUrl,
                      width: screenWidth * 0.16,
                      height: screenWidth * 0.16,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                if (showImage) SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.name,
                        style: AppTextStyles.subheading(context).copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                          color: AppColors.white,
                        ),
                      ),
                      if (showDescription)
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.006),
                          child: Text(
                            track.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body(context).copyWith(
                              fontSize: 14,
                              color: AppColors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      if (showProgress)
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.014),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: track.progress / 100,
                                  minHeight: screenHeight * 0.01,
                                  backgroundColor: Colors.white.withOpacity(0.05),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.004),
                              Text(
                                '${track.progress.toInt()}% Complete',
                                style: AppTextStyles.body(context).copyWith(
                                  fontSize: 12,
                                  color: AppColors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}