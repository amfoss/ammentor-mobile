import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/review/model/review_model.dart';

// Could've used the previous track_provider, but ideally all of these will be fetched from the backend later.

final List<ReviewTask> _allTasks = [
  ReviewTask(
    taskNumber: 0,
    icon: Icons.code,
    taskName: 'Codeforces',
    status: TaskStatus.reviewed,
  ),
  ReviewTask(
    taskNumber: 1,
    icon: HugeIcons.strokeRoundedGithub,
    taskName: 'Git',
    status: TaskStatus.reviewed,
  ),
  ReviewTask(
    taskNumber: 2,
    icon: HugeIcons.strokeRoundedGlobe02,
    taskName: 'Web Dev Basics',
    status: TaskStatus.reviewed,
  ),
  ReviewTask(
    taskNumber: 3,
    icon: HugeIcons.strokeRoundedCpu,
    taskName: 'Build a Simple Shell',
    status: TaskStatus.reviewed,
  ),
  ReviewTask(
    taskNumber: 4,
    icon: HugeIcons.strokeRoundedDoc01,
    taskName: 'Not a SRS Doc',
    status: TaskStatus.notreviewed,
  ),
  ReviewTask(
    taskNumber: 5,
    icon: HugeIcons.strokeRoundedWebDesign01,
    taskName: 'Wireframe the Skeleton',
    status: TaskStatus.notreviewed,
  ),
  ReviewTask(
    taskNumber: 6,
    icon: HugeIcons.strokeRoundedFigma,
    taskName: 'Figma Design Task',
    status: TaskStatus.notreviewed,
  ),
  ReviewTask(
    taskNumber: 7,
    icon: HugeIcons.strokeRoundedChrome,
    taskName: 'Frontend Development',
    status: TaskStatus.notreviewed,
  ),
  ReviewTask(
    taskNumber: 8,
    icon: HugeIcons.strokeRoundedDatabase,
    taskName: 'Backend Development',
    status: TaskStatus.notreviewed,
  ),
  ReviewTask(
    taskNumber: 9,
    icon: HugeIcons.strokeRoundedPlayStore,
    taskName: '	Flutter Development',
    status: TaskStatus.notreviewed,
  ),
];

class TaskReviewController extends StateNotifier<List<ReviewTask>> {
  TaskReviewController(Ref ref) : super(_allTasks) {
    final initialFilter = ref.read(activeTaskFilterProvider);
    filterTasks(initialFilter);
  }

  void filterTasks(String status) {
    if (status == 'notreviewed') {
      state =
          _allTasks
              .where((task) => task.status == TaskStatus.notreviewed)
              .toList();
    } else if (status == 'reviewed') {
      state =
          _allTasks
              .where((task) => task.status == TaskStatus.reviewed)
              .toList();
    } else {
      state = _allTasks;
    }
  }
}

final taskReviewControllerProvider =
    StateNotifierProvider<TaskReviewController, List<ReviewTask>>((ref) {
      return TaskReviewController(ref);
    });

final activeTaskFilterProvider = StateProvider<String>((ref) => 'notreviewed');
