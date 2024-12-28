abstract class MovieCardFavoriteState {}

class MovieCardFavoriteInitial extends MovieCardFavoriteState {}

class MovieCardFavoriteLoading extends MovieCardFavoriteState {}

class MovieCardFavoriteStatus extends MovieCardFavoriteState {
  final bool isFavorite;

  MovieCardFavoriteStatus(this.isFavorite);
}

class MovieCardFavoriteError extends MovieCardFavoriteState {
  final String error;

  MovieCardFavoriteError(this.error);
}