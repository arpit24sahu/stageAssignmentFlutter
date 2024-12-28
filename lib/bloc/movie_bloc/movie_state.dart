import '../../data/models/movie.dart';

abstract class MovieState{}

class MovieInitial extends MovieState{}
class MovieLoading extends MovieState{}
class MovieLoaded extends MovieState{
  bool onlyFavoriteMovies;
  List<Movie> movies;

  MovieLoaded(this.movies, this.onlyFavoriteMovies);
}

class MovieLoadError extends MovieState{
  String error;

  MovieLoadError(this.error);
}