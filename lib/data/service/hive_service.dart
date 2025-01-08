import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie.dart';

enum HiveBoxNames{
  favoriteMovies
}


class HiveService{
  static Future<void> initializeHive()async{
    await Hive.initFlutter();

    await Hive.openBox(HiveBoxNames.favoriteMovies.name);
  }

   Box favoriteBox() => Hive.box(HiveBoxNames.favoriteMovies.name);

}