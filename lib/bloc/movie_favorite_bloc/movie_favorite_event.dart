import '../../data/models/movie.dart';

abstract class MovieFavoriteEvent{}

class LoadFavoriteMovies extends MovieFavoriteEvent{}

class MovieFavoriteToggle extends MovieFavoriteEvent{
  Movie movie;
  MovieFavoriteToggle({required this.movie});
}


//
// abstract class MovieCardFavoriteEvent {}
//
// class CheckFavoriteStatus extends MovieCardFavoriteEvent {}
//
// class ToggleFavoriteStatus extends MovieCardFavoriteEvent {
//   final Movie movie;
//
//   ToggleFavoriteStatus(this.movie);
// }