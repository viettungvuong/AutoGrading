import 'package:flutter/material.dart';

import '../main.dart';

BottomNavigationBar BottomBar(){
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.add),
        label: 'Grade',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.library_books),
        label: 'Graded tests',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_rounded),
        label: 'Profile',
      ),
    ],
    currentIndex: currentScreenIndex,
    selectedItemColor: Colors.amber[800],
    onTap: (selected){
      currentScreenIndex = selected;
    },
  );
}
