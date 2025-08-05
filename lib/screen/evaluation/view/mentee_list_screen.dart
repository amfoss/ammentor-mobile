import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/mentee_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/view/mentee_tasks_screen.dart';
import 'package:ammentor/screen/evaluation/provider/mentee_list_provider.dart';

class MenteeListScreen extends ConsumerStatefulWidget {
  const MenteeListScreen({super.key});

  @override
  ConsumerState<MenteeListScreen> createState() => _MenteeListScreenState();
}

class _MenteeListScreenState extends ConsumerState<MenteeListScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  String _searchQuery = "";

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
    _animationController?.dispose();
    super.dispose();
  }

  List<dynamic> _filterMentees(List<dynamic> mentees) {
    if (_searchQuery.isEmpty) return mentees;
    return mentees.where((mentee) =>
      mentee.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      mentee.id.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Widget _buildSearchBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12, width: 0.7),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.white, size: 22),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: TextField(
              style: AppTextStyles.input(context).copyWith(color: AppColors.white),
              decoration: InputDecoration(
          hintText: "Search mentee by name or email",
          hintStyle: AppTextStyles.input(context).copyWith(color: AppColors.white70),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          fillColor: AppColors.background,
          filled: true,
              ),
              onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
              },
            ),
          ),
        ],
      ),
    );
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
            _buildSearchBar(context),
            Expanded(
              child: menteesAsync.when(
                data: (mentees) {
                  final filteredMentees = _filterMentees(mentees);
                  if (filteredMentees.isEmpty) {
                    return Center(child: Text('No mentees found', style: AppTextStyles.caption(context)));
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
