import '../../data/models/movie.dart';

abstract class MovieCardFavoriteEvent {}

class CheckFavoriteStatus extends MovieCardFavoriteEvent {
  final String movieId;

  CheckFavoriteStatus(this.movieId);
}

class ToggleFavoriteStatus extends MovieCardFavoriteEvent {
  final Movie movie;

  ToggleFavoriteStatus(this.movie);
}