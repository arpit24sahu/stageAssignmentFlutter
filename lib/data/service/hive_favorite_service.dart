import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie.dart';


class HiveFavoriteService{
  final Box favoriteBox;
  HiveFavoriteService({required this.favoriteBox});
  // get favorite movies from Hive
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