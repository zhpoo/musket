import 'package:flutter/material.dart';

mixin IndexMixin<T extends StatefulWidget> on State<T> {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    setCurrentIndex(index);
  }

  void setCurrentIndex(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }
}
