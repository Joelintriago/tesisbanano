import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/router/router.dart';


//Externos
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

//vistas
import 'package:admin_dashboard/ui/views/login_view.dart';
import 'package:admin_dashboard/ui/views/seguridad_view.dart';
import 'package:admin_dashboard/ui/views/modulos_view.dart';
import 'package:admin_dashboard/ui/views/change_password_view.dart';
import 'package:admin_dashboard/ui/views/edit_user_view.dart';
import 'package:admin_dashboard/ui/views/parametrizacion_view.dart';
import 'package:admin_dashboard/ui/views/operativo_view.dart';
import 'package:admin_dashboard/ui/views/report_view.dart';


class DashboardHandlers {
  //Dashboard Handler
  static Handler dashboard = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.dashboardRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const ModulosView2();
    } else {
      return const LoginView();
    }
  });

  //Operative Handler
  static Handler security = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.securityRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return UsersView();
    } else {
      return const LoginView();
    }
  });

  static Handler parametrizacion = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.parametrizacion);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return ParametrizacionView();
    } else {
      return const LoginView();
    }
  });

  static Handler editarUser = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.editRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return EditUserView();
    } else {
      return const LoginView();
    }
  });

  static Handler cambiarPass = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.changePassRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return ChangePasswordView();
    } else {
      return const LoginView();
    }
  });

  static Handler operativo = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.operativoRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return OperativoView();
    } else {
      return const LoginView();
    }
  });

  static Handler reportes = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.reporteRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return ReportesView();
    } else {
      return const LoginView();
    }
  });
}
