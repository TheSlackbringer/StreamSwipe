import 'package:get_it/get_it.dart';

import '../infrastructure/repositories/local_user_repository.dart';
import '../infrastructure/repositories/region_repository.dart';
import '../infrastructure/services/watch_provider_service.dart';

final getIt = GetIt.instance;

void setupDI() {
  // Register RegionRepository as a lazy singleton
  getIt.registerLazySingleton<RegionRepository>(() => RegionRepository());

  // Register LocalUserRepository as a lazy singleton
  getIt.registerLazySingleton<LocalUserRepository>(() => LocalUserRepository());

  getIt.registerLazySingleton<WatchProviderService>(() => WatchProviderService());

}