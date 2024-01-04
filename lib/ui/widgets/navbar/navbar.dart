import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/ui/widgets/navbar/navbar_item.dart';
import 'package:admin_dashboard/ui/widgets/navbar/navbar_user.dart';
import 'package:admin_dashboard/ui/widgets/sidebar/sidebar_item.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:admin_dashboard/router/lcoator.dart';
//import 'package:admin_dashboard/providers/route_provider.dart';
//import 'package:provider/provider.dart';

/*class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final rutaProvider = locator<RutaProvider>();

    return Container(
      height: screenHeight * 0.60,
      padding: EdgeInsets.only(bottom: screenHeight * 0.25),
      color: Colors.blue, // Cambia el color de fondo según tus preferencias
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'SISTEMA WEB DE GESTIÓN DE COSTOS Y RENTABILIDAD DE CULTIVO DE BANANO',
              style: TextStyle(
                color: Colors
                    .white, // Cambia el color del texto según tus preferencias
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            rutaProvider.currentRoute,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12, // Tamaño de fuente deseado
            ),
          
          ),
          IconButton(
            onPressed: () {
              // Implementa la acción para el botón de Opciones
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // Implementa la acción para el botón de Usuario
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // Implementa la acción para el botón de Cerrar Sesión
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }
}*/

enum Options { changePassword, logout }

enum SampleItem { itemOne, itemTwo, itemThree }

class NavBar extends StatefulWidget {
  const NavBar({Key? key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  SampleItem? selectedMenu;
  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);


    List<PopupMenuEntry<Options>> itemBuilder(context) => [
          const PopupMenuItem(
            value: Options.changePassword,
            child: Text('Change Password'),
          ),
          const PopupMenuItem(
            value: Options.logout,
            child: Text('Logout'),
          ),
        ];

    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context).user!;
    final token = LocalStorage.prefs.getString('token');

    return Builder(builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        height: 75,
        decoration: buildBoxDecoration(),
        child: Row(
          children: [
            if (size.width <= 779) ...[
              IconButton(
                onPressed: () {
                  SideMenuProvider.openMenu();
                },
                icon: const Icon(Icons.menu_outlined),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: Container(
                  width: 250,
                  child: const AutoSizeText(
                    'SISTEMA WEB DE COSTOS Y RENTABILIDAD DEL PROCESO DEL CULTIVO DEL BANANO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 5, // Número máximo de líneas permitidas
                    minFontSize: 10, // Tamaño de fuente mínimo
                    maxFontSize: 30, // Tamaño de fuente máximo
                    overflow: TextOverflow.ellipsis, // Opción de desbordamiento
                  ),
                ),
              ),
            ],
            if (size.width >= 779) ...[
              const SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: Container(
                  width: 250,
                  child: const AutoSizeText(
                    'SISTEMA WEB DE COSTOS Y RENTABILIDAD DEL PROCESO DEL CULTIVO DEL BANANO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 5, // Número máximo de líneas permitidas
                    minFontSize: 10, // Tamaño de fuente mínimo
                    maxFontSize: 30, // Tamaño de fuente máximo
                    overflow: TextOverflow.ellipsis, // Opción de desbordamiento
                  ),
                ),
              ),
              const Spacer(),
              NavbarItem(
                  text: 'Inicio',
                  icon: Icons.home_sharp,
                  onPressed: () {
                    NavigationService.replaceTo(Flurorouter.dashboardRoute);
                  }),
                NavbarUserItem.NavbarUserItem(text: user.firstName, icon: Icons.people),
              /*NavbarItem(
                text: 'Opciones de perfil',
                icon: Icons.settings,
                onPressed: () {}),*/
              /*NavbarItem(
                  text: 'Datos',
                  icon: Icons.people,
                  onPressed: () {
                    NavigationService.replaceTo('/dashboard/info/$token');
                  },
                  isActive: false),
              NavbarItem(
                  text: 'Password',
                  icon: Icons.people,
                  onPressed: () {
                    NavigationService.replaceTo(Flurorouter.changePassRoute);
                  },
                  isActive: false),
              NavbarItem(
                  text: user.firstName,
                  icon: Icons.people,
                  onPressed: () {
                    //crearMenu(context);
                  },
                  isActive: false),*/
              /*Container(
                  width: 50,
                  child: Overlay(
                    initialEntries: [
                      OverlayEntry(builder: (context) {
                        return PopupMenuButton(
                          onSelected: onSelected,
                          itemBuilder: itemBuilder,
                          child: navbarItem,
                        );
                      })
                    ],
                  )),*/
              MenuAnchor(
                builder: (BuildContext context, MenuController controller,
                    Widget? child) {
                  return NavbarItem(
                    text: 'Configuración de perfil',
                    icon: Icons.settings_sharp,
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                  );
                },
                menuChildren: [
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedMenu = SampleItem.itemOne;
                          // Agregar lógica para cambiar la contraseña
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets
                            .zero, // Ajustar el padding si es necesario
                        child: SidebarItem(
                          text: 'Editar perfil',
                          onPressed: () {
                            setState(() {
                              selectedMenu = SampleItem.itemOne;
                              // Agregar lógica para cambiar la contraseña
                            });
                            NavigationService.replaceTo(
                                '/dashboard/info/$token');
                          },
                          isActive:  sideMenuProvider.currentPage == Flurorouter.changeUserRoute,
                          icon: Icons.edit,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedMenu = SampleItem.itemTwo;
                          // Agregar lógica para actualizar la contraseña
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets
                            .zero, // Ajustar el padding si es necesario
                        child: SidebarItem(
                          text: 'Actualizar contraseña',
                          onPressed: () {
                            setState(() {
                              selectedMenu = SampleItem.itemTwo;
                              // Agregar lógica para actualizar la contraseña
                            });
                            NavigationService.replaceTo(
                                Flurorouter.changePassRoute);
                          },
                          isActive: sideMenuProvider.currentPage == Flurorouter.changePassRoute,
                          icon: Icons.refresh,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              NavbarItem(
                text: 'Salir',
                icon: Icons.exit_to_app_outlined,
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                },
              ),
            ],
          ],
        ),
      );
    });
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
              blurRadius: 5,
              color: Colors.black12,
            )
          ]);
}
