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

   Box get favoriteBox => Hive.box(HiveBoxNames.favoriteMovies.name);

  Future<List<Movie>> getFavoriteMovies() async {
    var movieIds = favoriteBox.keys;
    List<Movie> favoriteMovies = [];

    for (var movieId in movieIds) {
      var movieJson = favoriteBox.get(movieId);
      if (movieJson != null) {
        favoriteMovies.add(Movie.fromJson(movieJson.cast<String, dynamic>()));
      }
    }
    return favoriteMovies;
  }
}