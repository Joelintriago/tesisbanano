import 'package:flutter/material.dart';


class AuthLayout extends StatelessWidget {

  final Widget child;

  const AuthLayout({ required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}