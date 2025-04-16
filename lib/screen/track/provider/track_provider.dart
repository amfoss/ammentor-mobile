import 'package:flutter_riverpod/flutter_riverpod.dart';

final availableTracks = [
  'Vidyaratna',
  'AI',
  'Mobile Development',
  'Systems and Hardware',
];

final selectedTrackProvider = StateProvider<String>(
  (ref) => availableTracks[0],
);

final trackTasksProvider = Provider<Map<String, List<String>>>((ref) {
  return {
    'Vidyaratna': [
      'Codeforces',
      'Git',
      'Web Dev Basics',
      'Build a Simple Shell',
      'Not a SRS Doc',
      'Wireframe the Skeleton',
      'Figma Design Task',
      'Frontend development',
      'Backend Development',
      'Flutter Development',
    ],
    'AI': [
      'Machine Learning and fundamentals of AI',
      'Deep Learning',
      'Project',
    ],
    'Mobile Development': [
      'Advanced Flutter',
      'Native development using Kotlin',
      'Project',
    ],
    'Systems and Hardware': ['Linux fundamentals', 'Rust', 'Project'],
  };
});

final currentTrackTasksProvider = Provider<List<String>>((ref) {
  final selected = ref.watch(selectedTrackProvider);
  final allTasks = ref.watch(trackTasksProvider);
  return allTasks[selected] ?? [];
});
