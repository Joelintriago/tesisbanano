

import 'package:flutter/material.dart';

class NotificationsService {
  static late GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBarError(String message) {
    // Remueve cualquier notificación en la cola antes de mostrar una nueva.
    messengerKey.currentState!.removeCurrentSnackBar();

    final snackbar = SnackBar(
      backgroundColor: Colors.red.withOpacity(0.9),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white30, fontSize: 20),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackbar);
  }

    static showSnackBar(String message) {
    // Remueve cualquier notificación en la cola antes de mostrar una nueva.
    messengerKey.currentState!.removeCurrentSnackBar();

    final snackbar = SnackBar(
      backgroundColor: Colors.greenAccent.withOpacity(0.9),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white30, fontSize: 20),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackbar);
  }

  static void showSnackbarError(String s) {}
  
}
