import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/model/mentee_list_model.dart';

class MenteeListController extends StateNotifier<List<Mentee>> {
  MenteeListController() : super(_mentees);

  // Static data, again to be fetched from the database.
  static final List<Mentee> _mentees = [
    Mentee(
      id: '1',
      name: 'Mentee 0',
      imageUrl: 'https://avatar.iran.liara.run/public/8',
    ),
    Mentee(
      id: '2',
      name: 'Mentee 1',
      imageUrl: 'https://avatar.iran.liara.run/public/32',
    ),
    Mentee(
      id: '3',
      name: 'Mentee 2',
      imageUrl: 'https://avatar.iran.liara.run/public/4',
    ),
    Mentee(
      id: '4',
      name: 'Mentee 3',
      imageUrl: 'https://avatar.iran.liara.run/public/27',
    ),
    Mentee(
      id: '5',
      name: 'Mentee 4',
      imageUrl: 'https://avatar.iran.liara.run/public/18',
    ),
    Mentee(
      id: '6',
      name: 'Mentee 5',
      imageUrl: 'https://avatar.iran.liara.run/public/42',
    ),
    Mentee(
      id: '7',
      name: 'Mentee 6',
      imageUrl: 'https://avatar.iran.liara.run/public/13',
    ),
  ];
}

final menteeListControllerProvider =
    StateNotifierProvider<MenteeListController, List<Mentee>>((ref) {
      return MenteeListController();
    });
