import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/ui/widgets/sidebar/logo.dart';
import 'package:admin_dashboard/ui/widgets/sidebar/sidebar_item.dart';
import 'package:admin_dashboard/ui/widgets/sidebar/text_separator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  void navigateTo(String routeName) {
    NavigationService.navigateTo(routeName);
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    final token = LocalStorage.prefs.getString('token');

    return Container(
      width: 250,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Logo(),
          const SizedBox(
            height: 20,
          ),
          const TextSeparator(text: 'main'),
          SidebarItem(
            isActive:
                sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
            text: 'Inicio',
            icon: Icons.home_sharp,
            onPressed: () {
              NavigationService.replaceTo(Flurorouter.dashboardRoute);
            },
          ),
          SidebarItem(
            text: 'Editar perfil',
            icon: Icons.edit,
            onPressed: () {
              NavigationService.replaceTo('/dashboard/info/$token');
            },
            isActive:
                sideMenuProvider.currentPage == Flurorouter.changeUserRoute,
          ),
          SidebarItem(
            text: 'Actualizar contraseña',
            icon: Icons.refresh,
            onPressed: () {
              NavigationService.replaceTo(Flurorouter.changePassRoute);
            },
            isActive:
                sideMenuProvider.currentPage == Flurorouter.changePassRoute,
          ),
          //modulos
          const SizedBox(
            height: 8,
          ),
          const TextSeparator(text: 'modulos'),
          SidebarItem(
            isActive: sideMenuProvider.currentPage == Flurorouter.securityRoute,
            text: 'Modulo seguridad',
            icon: Icons.security,
            onPressed: () {
              NavigationService.replaceTo(Flurorouter.securityRoute);
            },
          ),
          SidebarItem(
            isActive:
                sideMenuProvider.currentPage == Flurorouter.parametrizacion,
            text: 'Modulo parametrizacion',
            icon: Icons.build,
            onPressed: () {
              NavigationService.replaceTo(Flurorouter.parametrizacion);
            },
          ),
          SidebarItem(
            isActive:
                sideMenuProvider.currentPage == Flurorouter.operativoRoute,
            text: 'Modulo operativo',
            icon: Icons.shopping_cart_checkout,
            onPressed: () {
              NavigationService.replaceTo(Flurorouter.operativoRoute);
            },
          ),

          SidebarItem(
            isActive: sideMenuProvider.currentPage == Flurorouter.reporteRoute,
            text: 'Modulo reportes',
            icon: Icons.analytics_outlined,
            onPressed: () {
              NavigationService.replaceTo(Flurorouter.reporteRoute);
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          SidebarItem(
            text: 'Salir',
            icon: Icons.exit_to_app_outlined,
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => const BoxDecoration(
      
          gradient: LinearGradient(
            begin: Alignment.centerLeft, // Comienza desde la izquierda
            end: Alignment.centerRight, // Termina en la derecha
            colors: [
              Color(0xFF679C64), // Color de inicio
              Color(0xFFADCFAB), // Color de finalización
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
            )
          ]);
}
