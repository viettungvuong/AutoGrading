import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../models/User.dart';

class BottomBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: (User.instance.isStudent==false?Icon(Icons.add):Icon(Icons.book_online)),
          label: (User.instance.isStudent==false?'Grade':'Exams'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Classes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Profile',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.account_circle_rounded),
        //   label: 'Profile',
        // ),
      ],
      currentIndex: ref.watch(selectedIndexProvider),
      selectedItemColor: Colors.amber[800],
      onTap: (selected) {
        ref.read(selectedIndexProvider.state).state = selected; // chinh so trong provider thanh selected
      },
      // Set type to BottomNavigationBarType.fixed to ensure all items are visible
      type: BottomNavigationBarType.fixed,
    );
  }
}
