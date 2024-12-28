import '../../data/models/movie.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final List<Movie> favoriteMovies;

  FavoriteSuccess(this.favoriteMovies);
}

class FavoriteFailure extends FavoriteState {
  final String error;

  FavoriteFailure(this.error);
}