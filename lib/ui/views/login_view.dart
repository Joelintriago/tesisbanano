import 'package:admin_dashboard/ui/widgets/card_login.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              lg: 6,
              md: 0,
              xs: 0, // En pantallas pequeñas, ocupa todo el ancho
              child: Container(
                // Contenido de la primera columna aquí
                height: MediaQuery.of(context).size.height,
              ),
            ),
            ResponsiveGridCol(
              lg: 6,
              md: 12,
              xs: 12, // En pantallas pequeñas, ocupa todo el ancho
              child: Container(
                // Contenido de la segunda columna aquí
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 30, bottom: 30, left: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(colors: [
                          Colors.green[900]!.withOpacity(0.8), // Verde oscuro
                          Colors.green[300]!.withOpacity(0.8),
                        ])),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const SingleChildScrollView(child: CardLogin()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

