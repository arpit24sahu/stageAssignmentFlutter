abstract class MovieEvent{}

class FetchMovies extends MovieEvent{
  int page;
  FetchMovies(this.page);
}

class FetchMoreMovies extends MovieEvent{
  int page;
  FetchMoreMovies(this.page);
}

class OnlyShowFavoriteMovies extends MovieEvent{
  bool onlyFavorites;
  OnlyShowFavoriteMovies(this.onlyFavorites);
}



