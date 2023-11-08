import 'package:get_it/get_it.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/providers/route_provider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => RutaProvider());
}