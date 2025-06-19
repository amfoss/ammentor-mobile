import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/track/model/track_model.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final void Function(Track) onTrackTap;

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => onTrackTap(track),
          splashColor: Colors.white.withOpacity(0.1), // Ripple color
          highlightColor: Colors.white.withOpacity(0.05), // Press color
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Row with Image/Icon + Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showImage)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey[900],
                              child: Image.network(
                                track.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.auto_graph_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        if (showImage) const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            track.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (showDescription) const SizedBox(height: 14),
                    if (showDescription)
                      Text(
                        track.description,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.white.withOpacity(0.75),
                          height: 1.45,
                        ),
                      ),

                    if (showProgress) const SizedBox(height: 20),
                    if (showProgress)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                              value: track.progress / 100,
                              minHeight: 5,
                              backgroundColor: Colors.white.withOpacity(0.08),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${track.progress.toInt()}% Complete',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}