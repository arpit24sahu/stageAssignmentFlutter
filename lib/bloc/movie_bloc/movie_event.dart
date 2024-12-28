abstract class MovieEvent{}

class FetchMovies extends MovieEvent{
  int page;
  FetchMovies(this.page);
}
