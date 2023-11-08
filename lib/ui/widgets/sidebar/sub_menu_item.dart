import 'package:admin_dashboard/ui/widgets/sidebar/sidebar_item.dart';
import 'package:flutter/material.dart';

class SidebarItemWithSubMenu extends StatelessWidget {
  final String text;
  final IconData icon;
  final List<SidebarItem> subItems; // Lista de subitems
  final void Function()? onPressed;

  const SidebarItemWithSubMenu({
    required this.text,
    required this.icon,
    required this.subItems,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: SidebarItem(
        text: text,
        icon: icon,
        onPressed: (){},
      ),
      children: subItems, // Agrega los subitems aquí
    );
  }
}