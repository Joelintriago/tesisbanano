//import 'package:admin_dashboard/router/admin_handlers.dart';
import 'package:admin_dashboard/providers/init_provider.dart';
import 'package:admin_dashboard/providers/login_form_provider.dart';
import 'package:flutter/material.dart';


import 'package:admin_dashboard/api/CafeApi.dart';

import 'package:admin_dashboard/ui/layouts/auth/auth_layout.dart';
import 'package:admin_dashboard/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:admin_dashboard/ui/layouts/splash/splash_layout.dart';

//Providers
import 'package:provider/provider.dart';
import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/providers/users_provider.dart';

//Services
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/notification_service.dart';

//Router
import 'package:admin_dashboard/router/lcoator.dart';
import 'package:admin_dashboard/router/router.dart';

import 'package:responsive_grid/responsive_grid.dart';



import 'package:url_strategy/url_strategy.dart';

void main() async{
  await LocalStorage.configurePrefs();
  CafeApi.configureDio();
  setPathUrlStrategy();
  setupLocator();
  Flurorouter.configureRoutes();
  runApp(AppState());
  ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
    xs: 600,
    sm: 905,
    md: 1240,
    lg: 1440,
  );
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>AuthProvider(),lazy: false,),
        ChangeNotifierProvider(create: (_)=> SideMenuProvider(),lazy: false,),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => LoginFormProvider(),),
        ChangeNotifierProvider(create: (_) =>MiInicializador(),),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BananoProject',
      initialRoute: '/',
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      builder: (_, child) {

        final authProvider = Provider.of<AuthProvider>(context);

        if (authProvider.authStatus == AuthStatus.checking){
          return SplashLayout();
        }

        if(authProvider.authStatus == AuthStatus.authenticated){
          return DashboardLayout(child: child!);
        }else{
          return AuthLayout(child: child!);
        }
        //print(LocalStorage.prefs.getString('token'));

      },
    );
  }
}
