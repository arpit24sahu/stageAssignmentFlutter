
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:instabot/data/service/hive_service.dart';

import 'data/repositories/movie_repository.dart';
import 'data/service/hive_favorite_service.dart';

final MovieRepository movieRepository = MovieRepository();
final Connectivity connectivity = Connectivity();
final HiveService hiveService = HiveService();


class DotEnvKeys{
  static const String tmdbApiAccessToken = "TMDB_API_ACCESS_TOKEN";
  static const String tmdbApiKey = "TMDB_API_KEY";
}

class TmdbApi{
  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String trendingMoviesEndpoint = "/trending/movie/day";
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";
}