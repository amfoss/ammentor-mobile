import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/mentee_tile.dart';
import 'package:ammentor/components/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/mentor-evaluation/view/mentee_tasks_screen.dart';
import 'package:ammentor/screen/mentor-evaluation/provider/mentee_list_provider.dart';

class MenteeListScreen extends ConsumerStatefulWidget {
  const MenteeListScreen({super.key});

  @override
  ConsumerState<MenteeListScreen> createState() => _MenteeListScreenState();
}

class _MenteeListScreenState extends ConsumerState<MenteeListScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menteesAsync = ref.watch(menteeListControllerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Task Review',
          style: AppTextStyles.subheading(context).copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.001),
            Text(
              'Choose the mentee',
              style: AppTextStyles.subheading(context).copyWith(),
            ),
            SizedBox(height: screenHeight * 0.02,
                child: Divider(
                color: AppColors.grey,
                thickness: 1.0,
              ),),

            SizedBox(height: screenHeight * 0.01),

            CustomTextField(
              controller: searchController,
              label: "Search",
              hintText: "Search Mentee...",
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              width: screenWidth,
            ),

            SizedBox(height: screenHeight * 0.01),
            
            Expanded(
              child: menteesAsync.when(
                data: (mentees) {
                  final filteredMentees = mentees.where((mentee) {
                    return mentee.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();

                  if (filteredMentees.isEmpty) {
                    return Center(child: Text(searchQuery.isEmpty ? 'No mentees available' : "No mentees found", style: AppTextStyles.caption(context)));
                  }

                  return AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, child) {
                      return ListView.builder(
                        itemCount: filteredMentees.length,
                        itemBuilder: (context, index) {
                          final mentee = filteredMentees[index];
                          return FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _animationController!,
                                curve: Interval(
                                  index * 0.05,
                                  1.0,
                                  curve: Curves.easeIn,
                                ),
                              ),
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.2),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _animationController!,
                                  curve: Interval(
                                    index * 0.05,
                                    1.0,
                                    curve: Curves.easeIn,
                                  ),
                                ),
                              ),
                              child: MenteeTile(
                                number: index + 1,
                                mentee: mentee,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              MenteeTasksScreen(mentee: mentee),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Failed to load mentees', style: AppTextStyles.caption(context))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
