import 'package:hive/hive.dart';

import '../api/movie_api.dart';
import '../models/movie.dart';

class  MovieRepository {

  static Future<List<Movie>> getMovies({int page = 1}) async {
    try {
      final response = await MovieApi.getTrendingMovies(page);
      final List<dynamic> results = response['results'] ?? [];
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

//   Future<List<Movie>> getFavoritesMovies(){
//
//   }
//
//
// Future<void> toggleFavorite(Movie movie){
//
// }
//
//   bool isMovieFavorite(int id){
//
//   }

}