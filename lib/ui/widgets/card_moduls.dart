import 'package:flutter/material.dart';

class ModulosCard extends StatefulWidget {
  final String imagePath;
  final String text;
  final Function()? onPressed;

  const ModulosCard({
    Key? key,
    required this.imagePath,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ModulosCard> createState() => _ModulosCardState();
}

class _ModulosCardState extends State<ModulosCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()..scale(1.1);
    final transform = isHover ? hoveredTransform : Matrix4.identity();

    return AnimatedContainer(
      duration: const Duration(microseconds: 800),
      transform: transform,
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: widget.onPressed,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => isHover = true),
            onExit: (_) => setState(() => isHover = false),
            child: Container(
              width: 350.0, // Ancho deseado para los Cards
              height: 300.0, // Alto deseado para los Cards
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      widget.imagePath,
                      width: double.infinity, // Ancho máximo
                      height: double.infinity, // Alto máximo
                    ),
                  ),
                  const SizedBox(
                      height: 16.0), // Espacio entre la imagen y el texto
                  Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
