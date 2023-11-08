import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/ui/views/modulos_view.dart';
import 'package:fluro/fluro.dart';

//vistas
import 'package:admin_dashboard/ui/views/login_view.dart';
import 'package:admin_dashboard/ui/views/recovery_view.dart';
import 'package:provider/provider.dart';

class AdminHandlers {
  static Handler login = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    if (authProvider.authStatus == AuthStatus.notAuthenticated) {
      return const LoginView();
    } else {
      return const ModulosView2();
    }
  });

  static Handler modules = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    if (authProvider.authStatus == AuthStatus.notAuthenticated) {
      return const RecoveryView();
    } else {
      return const ModulosView2();
    }
  });


}
/*Route<dynamic> generateRoute(RouteSettings settings) {
  final rutaProvider = locator<RutaProvider>();

  switch (settings.name) {
    case loginRoute:
      rutaProvider.updateCurrentRoute(loginRoute);
      return _getPageRoute(const LoginView(), settings);

    case moduleRoute:
      rutaProvider.updateCurrentRoute(moduleRoute);
      return _getPageRoute(const ModulosView2(), settings);

    case homeRoute:
      rutaProvider.updateCurrentRoute(homeRoute);
      return _getPageRoute(const HomeView(), settings);

    case recoveryRoute:
      rutaProvider.updateCurrentRoute(recoveryRoute);
      return _getPageRoute(const RecoveryView(), settings);

    default:
      rutaProvider.updateCurrentRoute(loginRoute);
      return _getPageRoute(const LoginView(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) => child,
    settings: RouteSettings(name: settings.name),
  );
}*/


