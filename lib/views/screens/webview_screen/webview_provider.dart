import 'package:flutter/material.dart';

class WebViewProvider extends ChangeNotifier {
  int _progress = 0;

  int get progress => _progress;

  void updateProgress(int value) {
    _progress = value;
    notifyListeners();
  }
}