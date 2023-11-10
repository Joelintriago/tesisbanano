

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
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackbar);
  }

    static showSnackBar(String message) {
    // Remueve cualquier notificación en la cola antes de mostrar una nueva.
    messengerKey.currentState!.removeCurrentSnackBar();

    final snackbar = SnackBar(
      backgroundColor: Colors.green.withOpacity(0.9),
      content: Text(
        message,
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackbar);
  }

  static void showSnackbarError(String s) {}
  
}
