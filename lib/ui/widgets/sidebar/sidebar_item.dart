import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarItem extends StatefulWidget {
  final String text;
  final Function onPressed;
  final bool isActive;
  final IconData icon;

  const SidebarItem({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isActive = false,
    required this.icon,
  }) : super(key: key);

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isHover
        ? const Color(0xFF184D26)
        : widget.isActive
            ? const Color(0xFF184D26)
            : Colors.transparent;
    return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: backgroundColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: widget.isActive ? null : () => widget.onPressed(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: MouseRegion(
                  onEnter: (_) => setState(() {
                    isHover = true;
                  }),
                  onExit: (_) => setState(() {
                    isHover = false;
                  }),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(widget.icon),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.text,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }
}
