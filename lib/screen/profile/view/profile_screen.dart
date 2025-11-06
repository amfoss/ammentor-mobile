import 'package:ammentor/screen/profile/provider/user_provider.dart';
import 'package:ammentor/screen/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ammentor/screen/auth/provider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ammentor/screen/leaderboard/model/leaderboard_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(userEmailProvider);

    if (email == null) {
      return const Center(child: Text("Email not found. Please login."));
    }

    final userAsync = ref.watch(userProvider(email));
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: AppTextStyles.subheading(context).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        error: (err, _) => Center(
          child: Text(
            'Error: $err',
            style: AppTextStyles.body(context).copyWith(
              color: AppColors.errorDark,
            ),
          ),
        ),
        data: (user) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),

                  // --- Profile Card ---
                  _buildProfileCard(context, user, screenWidth, screenHeight),
                  
                  SizedBox(height: screenHeight * 0.025),

                  // --- Stats Row ---
                  _buildStatsRow(context, user, screenWidth, screenHeight),
                  
                  SizedBox(height: screenHeight * 0.025),

                  // --- Badges Section ---
                  // _buildBadgesSection(context, user, screenWidth, screenHeight),
                  
                  SizedBox(height: screenHeight * 0.04),

                  // --- Logout Button ---
                  _buildLogoutButton(context, ref, screenWidth, screenHeight),
                  
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic user, double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: AppColors.darkgrey.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
              radius: 32,
              backgroundColor: Colors.grey[800],
            ),
          ),
          SizedBox(width: screenWidth * 0.05),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.body(context).copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.008),
                Text(
                  user.email,
                  style: AppTextStyles.caption(context).copyWith(
                    fontSize: 14,
                    color: AppColors.white.withOpacity(0.65),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    user.role,
                    style: AppTextStyles.caption(context).copyWith(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, dynamic user, double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.045),
      decoration: BoxDecoration(
        color: AppColors.darkgrey.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              HugeIcons.strokeRoundedAnalytics01,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Points",
                  style: AppTextStyles.caption(context).copyWith(
                    fontSize: 14,
                    color: AppColors.white.withOpacity(0.65),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  user.total_points.toString(),
                  style: AppTextStyles.body(context).copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBadgesSection(BuildContext context, dynamic user, double screenWidth, double screenHeight) {
  //   return Container(
  //     padding: EdgeInsets.all(screenWidth * 0.05),
  //     decoration: BoxDecoration(
  //       color: AppColors.darkgrey.withOpacity(0.9),
  //       borderRadius: BorderRadius.circular(18),
  //       border: Border.all(
  //         color: Colors.white.withOpacity(0.08),
  //         width: 0.5,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.12),
  //           blurRadius: 12,
  //           offset: const Offset(0, 4),
  //           spreadRadius: 0,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(10),
  //               decoration: BoxDecoration(
  //                 color: Colors.amber.withOpacity(0.15),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: const Icon(
  //                 HugeIcons.strokeRoundedCheckmarkBadge02,
  //                 color: Colors.amber,
  //                 size: 20,
  //               ),
  //             ),
  //             SizedBox(width: screenWidth * 0.04),
  //             Text(
  //               'Achievements',
  //               style: AppTextStyles.body(context).copyWith(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 letterSpacing: -0.2,
  //               ),
  //             ),
  //             const Spacer(),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Text(
  //                 '${user.badges.length}',
  //                 style: AppTextStyles.caption(context).copyWith(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w600,
  //                   color: AppColors.white.withOpacity(0.8),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: screenHeight * 0.02),
  //         user.badges.isNotEmpty
  //             ? Wrap(
  //                 spacing: 12,
  //                 runSpacing: 12,
  //                 children: user.badges.map<Widget>((badge) {
  //                   return Container(
  //                     width: 50,
  //                     height: 50,
  //                     decoration: BoxDecoration(
  //                       gradient: LinearGradient(
  //                         colors: [
  //                           AppColors.primary,
  //                           AppColors.primary.withOpacity(0.8),
  //                         ],
  //                         begin: Alignment.topLeft,
  //                         end: Alignment.bottomRight,
  //                       ),
  //                       borderRadius: BorderRadius.circular(16),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: AppColors.primary.withOpacity(0.3),
  //                           blurRadius: 8,
  //                           offset: const Offset(0, 4),
  //                         ),
  //                       ],
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         badge[0],
  //                         style: const TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 }).toList(),
  //               )
  //             : Container(
  //                 padding: const EdgeInsets.all(20),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white.withOpacity(0.05),
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(
  //                     color: Colors.white.withOpacity(0.1),
  //                     width: 1,
  //                     style: BorderStyle.solid,
  //                   ),
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'No badges earned yet',
  //                     style: AppTextStyles.caption(context).copyWith(
  //                       color: AppColors.white.withOpacity(0.5),
  //                       fontStyle: FontStyle.italic,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref, double screenWidth, double screenHeight) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.errorDark.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
            await storage.deleteAll();
            ref.invalidate(userEmailProvider);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorDark,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.2,
              vertical: screenHeight * 0.018,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout_rounded,
                size: 18,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                'Sign Out',
                style: AppTextStyles.button(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}