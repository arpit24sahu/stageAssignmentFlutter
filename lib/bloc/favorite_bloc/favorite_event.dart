import '../../data/models/movie.dart';

abstract class FavoriteEvent {}

class LoadFavorites extends FavoriteEvent {}

class AddToFavorites extends FavoriteEvent {
  final Movie movie;

  AddToFavorites(this.movie);
}

class RemoveFromFavorites extends FavoriteEvent {
  final String movieId;

  RemoveFromFavorites(this.movieId);
}