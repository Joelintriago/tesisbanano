import 'package:admin_dashboard/router/admin_handlers.dart';
import 'package:admin_dashboard/router/dashboard_handlers.dart';
import 'package:admin_dashboard/router/no_page_found_handlers.dart';
import 'package:fluro/fluro.dart';


class Flurorouter{
  static final FluroRouter router = new FluroRouter();

  static String rootRoute = '/';

  //Auth Router
  static String loginRoute     = '/auth/login';
  static String registerRoute  = '/auth/register';
  static String recoveryRoute  = '/auth/recoveryPassword';

  //Dashboard
  static String dashboardRoute  = '/dashboard';
  static String securityRoute   = '/dashboard/seguridad';
  static String editRoute       = '/dashboard/editarUsuario';
  static String changePassRoute = '/dashboard/changePassword';
  static String parametrizacion = '/dashboard/parametrizacion';
  static String operativoRoute  = '/dashboard/operativo';
  static String reporteRoute    = '/dashboard/reporte';
  static String changeUserRoute = '/dashboard/info';


  static void configureRoutes(){
    //Auth Routes
    router.define(rootRoute, handler: AdminHandlers.login,transitionType: TransitionType.none);
    router.define(loginRoute, handler: AdminHandlers.login,transitionType: TransitionType.none);
    router.define(recoveryRoute, handler: AdminHandlers.modules,transitionType: TransitionType.none);

    //Dashboard
    router.define(dashboardRoute, handler: DashboardHandlers.dashboard,transitionType: TransitionType.none);
    router.define(securityRoute, handler:DashboardHandlers.security,transitionType: TransitionType.none);
    router.define(parametrizacion, handler: DashboardHandlers.parametrizacion,transitionType: TransitionType.none);
    router.define(operativoRoute, handler: DashboardHandlers.operativo,transitionType: TransitionType.none);
    router.define(reporteRoute, handler: DashboardHandlers.reportes,transitionType: TransitionType.none);

    router.define(editRoute, handler: DashboardHandlers.editarUser,transitionType: TransitionType.none);
    router.define(changePassRoute, handler: DashboardHandlers.cambiarPass,transitionType: TransitionType.none);
    router.define(changeUserRoute,handler: DashboardHandlers.changeUserView,transitionType: TransitionType.none);


    //404
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }

} 
