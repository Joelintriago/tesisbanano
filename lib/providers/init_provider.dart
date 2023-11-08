import 'package:flutter/material.dart';

class MiInicializador extends ChangeNotifier {
  int _c = 0;
  int get c => _c;

  void incrementC() {
    _c++;
    notifyListeners();
  }
}