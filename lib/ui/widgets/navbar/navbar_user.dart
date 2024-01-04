import 'package:flutter/material.dart';

class NavbarUserItem extends StatelessWidget {
  final String text;
  final IconData icon;

  const NavbarUserItem.NavbarUserItem({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(icon),
          SizedBox(width: 5), // Espacio entre el ícono y el texto
          Text(text),
        ],
      ),
    );
  }
}
