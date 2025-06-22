import 'package:flutter/material.dart';

class NavigationBarNotifier with ChangeNotifier {
  int selectedIndex = 0;
  void onIndexSelected(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
