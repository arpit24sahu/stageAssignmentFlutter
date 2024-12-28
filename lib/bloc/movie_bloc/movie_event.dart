abstract class MovieEvent{}

class FetchMovies extends MovieEvent{
  bool onlyFavorites;
  int page;
  FetchMovies(this.onlyFavorites, this.page);
}
