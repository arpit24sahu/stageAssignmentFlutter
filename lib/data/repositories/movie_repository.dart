import '../api/movie_api.dart';
import '../models/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies({int page = 1});
}

class MovieRepositoryImpl implements MovieRepository {
  @override
  Future<List<Movie>> getMovies({int page = 1}) async {
    try {
      final response = await MovieApi.getTrendingMovies(page);
      final List<dynamic> results = response['results'] ?? [];
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception('$e');
    }
  }
}