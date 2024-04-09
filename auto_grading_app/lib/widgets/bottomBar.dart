import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class BottomBar extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Grade',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Profile',
        ),
      ],
      currentIndex: ref.watch(selectedIndexProvider),
      selectedItemColor: Colors.amber[800],
      onTap: (selected){
        ref.read(selectedIndexProvider.state).state = selected;
      },
    );
  }

}
