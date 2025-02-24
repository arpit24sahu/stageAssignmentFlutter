abstract class MovieEvent{}

class FetchMovies extends MovieEvent{}

class FetchMoreMovies extends MovieEvent{}

class FavoriteMoviesToggle extends MovieEvent{
  bool onlyFavorites;
  FavoriteMoviesToggle(this.onlyFavorites);
}



