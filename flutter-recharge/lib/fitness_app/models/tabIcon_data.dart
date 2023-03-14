import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
    this.name = ''
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  String name;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/fitness_app/tab_1.png',
      selectedImagePath: 'assets/fitness_app/tab_1s.png',
      index: 0,
      isSelected: true,
      animationController: null,
      name: 'dash'
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_2.png',
      selectedImagePath: 'assets/fitness_app/tab_2s.png',
      index: 1,
      isSelected: false,
      animationController: null,
      name: 'jawaker_acceleration'
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_3.png',
      selectedImagePath: 'assets/fitness_app/tab_3s.png', 
      index: 2,
      isSelected: false,
      animationController: null,
      name: 'token'
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_4.png',
      selectedImagePath: 'assets/fitness_app/tab_4s.png',
      index: 3, 
      isSelected: false,
      animationController: null,
      name: 'notification'
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_5.png',
      selectedImagePath: 'assets/fitness_app/tab_5s.png',
      index: 4, 
      isSelected: false,
      animationController: null,
      name: 'transaction'
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_6.png',
      selectedImagePath: 'assets/fitness_app/tab_6s.png',
      index: 5, 
      isSelected: false,
      animationController: null,
      name: 'history'
    ),
  ];
}
