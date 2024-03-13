import 'package:auto_grading_mobile/controllers/appController.dart';
import 'package:flutter/material.dart';

BottomNavigationBar bottomBar(){
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.business),
        label: 'Business',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        label: 'School',
      ),
    ],
    currentIndex: currentScreenIndex,
    selectedItemColor: Colors.amber[800],
    onTap: (selected){
      currentScreenIndex = selected;
    },
  );
}
