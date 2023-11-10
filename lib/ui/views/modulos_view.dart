
import 'package:admin_dashboard/providers/auth_provider.dart';

import 'package:admin_dashboard/services/notification_service.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/ui/widgets/card_moduls.dart';
import 'package:provider/provider.dart';


import 'package:responsive_grid/responsive_grid.dart';

/*class ModulosView extends StatelessWidget {
  const ModulosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        color: const Color.fromARGB(137, 218, 212, 190),
        child: Padding(
          padding: const EdgeInsets.all(60),
          child: GridView.count(
            crossAxisSpacing: 20.0, // Espacio horizontal entre elementos
            mainAxisSpacing: 20.0,
            childAspectRatio: 3,
            shrinkWrap: true,
            crossAxisCount:
                responsiveValue(context, xs: 1, sm: 1, md: 2, lg: 2),
            children: const [
              ModulosCard(moduloNumber: 1),
              ModulosCard(moduloNumber: 2),
              ModulosCard(moduloNumber: 3),
              ModulosCard(moduloNumber: 4),
            ],
          ),
        ),
      ),
    );
  }
}*/

class ModulosView2 extends StatefulWidget {
  

  const ModulosView2({Key? key}) : super(key: key);

  @override
  State<ModulosView2> createState() => _ModulosView2State();
}
@override


class _ModulosView2State extends State<ModulosView2> {
 

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    return SingleChildScrollView(
      child: Container(
        color: const Color.fromARGB(183, 198, 199, 157).withOpacity(0.9),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              xs: 12,
              md: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        child: ModulosCard(
                      imagePath: 'assets/modul_seguridad.png',
                      text: 'MÓDULO DE SEGURIDAD',
                      onPressed: ()  {
                          final roleCode = authProvider.user?.roles?[0].roleCode ?? "";
                          if(roleCode == '002'){
                            NotificationsService.showSnackBarError('No tienes permisos');
                          }else{
                            NavigationService.replaceTo(Flurorouter.securityRoute);
                          }
                      },
                    )),
                    Flexible(
                        child: ModulosCard(
                      imagePath: 'assets/modul_parametrizacion.jpeg',
                      text: 'MÓDULO DE PARAMETRIZACIÓN',
                      onPressed: () {
                        NavigationService.replaceTo(
                            Flurorouter.parametrizacion);
                      },
                    ))
                  ],
                ),
              ),
            ),
            ResponsiveGridCol(
              xs: 12,
              md: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        child: ModulosCard(
                      imagePath: 'assets/modul_operativo.png',
                      text: 'MÓDULO OPERATIVO',
                      onPressed: (){
                        NavigationService.replaceTo(Flurorouter.operativoRoute);
                      },
                    )),
                    Flexible(
                        child: ModulosCard(
                      imagePath: 'assets/modul_reporte.png',
                      text: 'MÓDULO DE REPORTES',
                      onPressed: (){
                        NavigationService.replaceTo(Flurorouter.reporteRoute);
                      },
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
