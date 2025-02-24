import '../../data/models/movie.dart';

abstract class MovieCardFavoriteState {}

abstract class MovieFavoriteState{}

class MovieFavoritesLoading extends MovieFavoriteState{}

class MovieFavoritesLoaded extends MovieFavoriteState{
  List<Movie> favoriteMovies;
  Movie? movie;
  MovieFavoritesLoaded({required this.favoriteMovies, this.movie});
}

class MovieFavoritesError extends MovieFavoriteState{
  String errorMessage;
  MovieFavoritesError({required this.errorMessage});
}





//
// class MovieCardFavoriteInitial extends MovieCardFavoriteState {}
//
// class MovieCardFavoriteLoading extends MovieCardFavoriteState {}
//
// class MovieCardFavoriteStatus extends MovieCardFavoriteState {
//   final bool isFavorite;
//
//   MovieCardFavoriteStatus(this.isFavorite);
// }
//
// class MovieCardFavoriteError extends MovieCardFavoriteState {
//   final String error;
//
//   MovieCardFavoriteError(this.error);
// }