import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/ui/widgets/navbar/navbar.dart';
import 'package:admin_dashboard/ui/widgets/sidebar/sidebar.dart';
import 'package:flutter/material.dart';
// Importa tu barra de navegación

class DashboardLayout extends StatefulWidget {
  final Widget child;

  const DashboardLayout({ required this.child});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SideMenuProvider.menuController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/moduls_background.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const NavBar( ),

                    //navbar
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ],
          ),
          if (size.width <= 779)
            AnimatedBuilder(
                animation: SideMenuProvider.menuController,
                builder: (context, _) => Stack(
                      children: [
                        if (SideMenuProvider.isOpen)
                          Opacity(
                            opacity: 0.7,
                            child: GestureDetector(
                              onTap: () {
                                SideMenuProvider.closeMenu();
                              },
                              child: Container(
                                width: size.width,
                                height: size.height,
                                color: Colors.black12,
                              ),
                            ),
                          ),
                        Transform.translate(
                          offset: Offset(SideMenuProvider.movement.value, 0),
                          child: Sidebar(),
                        ),
                      ],
                    ))
        ],
      ),
    ));
  }
}
