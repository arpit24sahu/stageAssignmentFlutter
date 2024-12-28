import '../../data/models/movie.dart';

abstract class MovieState{}

class MovieInitial extends MovieState{}
class MovieLoading extends MovieState{}
class MovieLoaded extends MovieState{
  List<Movie> movies;

  MovieLoaded(this.movies);
}

class MovieLoadError extends MovieState{
  String error;

  MovieLoadError(this.error);
}