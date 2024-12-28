import '../../data/models/movie.dart';

abstract class MovieCardFavoriteEvent {}

class CheckFavoriteStatus extends MovieCardFavoriteEvent {}

class ToggleFavoriteStatus extends MovieCardFavoriteEvent {
  final Movie movie;

  ToggleFavoriteStatus(this.movie);
}