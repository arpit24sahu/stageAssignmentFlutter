import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:instabot/data/service/hive_service.dart';
import 'package:instabot/data/repositories/movie_repository.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register instances
  locator.registerLazySingleton<MovieRepository>(() => MovieRepository());
  locator.registerLazySingleton<Connectivity>(() => Connectivity());
  locator.registerLazySingleton<HiveService>(() => HiveService());
}

