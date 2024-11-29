import 'package:get_it/get_it.dart';

import 'flavour.dart';

final locator = GetIt.instance;

/// Register all the controllers and services
Future<void> setUpLocator(AppFlavorConfig config) async {
  locator.registerLazySingleton<AppFlavorConfig>(() => config);
  await _registerExternalDependencies();
  _registerServices();
  _registerController();
  _registerRepositories();
}

void _registerServices() async {
  // locator.registerLazySingleton<NavigationService>(() => NavigationService());
}

void _registerController() async {}

Future<void> _registerExternalDependencies() async {}

Future<void> _registerRepositories() async {}
