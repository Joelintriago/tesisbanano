import 'package:flutter/material.dart';

class NavbarItem extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isActive;
  final Function onPressed;

  const NavbarItem({
    required this.text,
    required this.icon,
    this.isActive = false,
    required this.onPressed,
  });

  @override
  State<NavbarItem> createState() => _NavbarItemState();
}

class _NavbarItemState extends State<NavbarItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: widget.isActive ? null : () => widget.onPressed(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: MouseRegion(
            onEnter: (_) => setState(() {
              isHover = true;
            }),
            onExit: (_) => setState(() {
              isHover = false;
            }),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(widget.icon),
                Text(
                  widget.text,
                  style: TextStyle(
                    decoration: isHover
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
