import 'package:flutter/material.dart';

class RutaProvider extends ChangeNotifier {
  String _currentRoute = '/login'; // Ruta inicial, puedes cambiarla según tus necesidades

  String get currentRoute => _currentRoute;

  void updateCurrentRoute(String newRoute) {
    _currentRoute = newRoute;
    notifyListeners();
  }
}