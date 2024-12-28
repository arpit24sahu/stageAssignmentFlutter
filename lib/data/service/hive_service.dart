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

  // get favorite movies from Hive
  static Future<List<Movie>> getFavoriteMovies() async {
    var box = await Hive.openBox(HiveBoxNames.favoriteMovies.name);
    var movieIds = box.keys;
    List<Movie> favoriteMovies = [];

    for (var movieId in movieIds) {
      var movieJson = box.get(movieId);
      if (movieJson != null) {
        favoriteMovies.add(Movie.fromJson(movieJson.cast<String, dynamic>()));
      }
    }
    return favoriteMovies;
  }
}