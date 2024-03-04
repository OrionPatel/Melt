import 'package:flutter/material.dart';

// class LikeButtonColorProvider extends ChangeNotifier {
//   bool _isLiked = false;

//   bool get isLiked => _isLiked;

//   void toggleLiked() {
//     _isLiked = !_isLiked;
//     notifyListeners();
//   }
// }

class NavIndexProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
