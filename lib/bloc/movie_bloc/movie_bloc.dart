import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:instabot/locator.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';
import '../../data/service/hive_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {

  List<Movie> loadedMovies = [];
  int currentPage = 1;

  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<FetchMoreMovies>(_onFetchMoreMovies);
    on<FavoriteMoviesToggle>(_onOnlyShowFavoriteMovies);
  }

  Future<bool> _connectivityAvailable() async {
    List<ConnectivityResult> connectivityResults = await locator<Connectivity>().checkConnectivity();
    // print(connectivityResults);
    if(
    connectivityResults.contains(ConnectivityResult.wifi)
        ||
        connectivityResults.contains(ConnectivityResult.mobile
        )){
      return true;
    }
    return false;
  }

  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    currentPage = 1;
    try {
      if(!(await _connectivityAvailable())){
        emit(MovieLoadError("No internet connection. Please check your network and try again."));
        return;
      }

      loadedMovies = await locator<MovieRepository>().getMovies();
      emit(MovieLoaded(loadedMovies, false));
    } catch (e) {
      emit(MovieLoadError(e.toString()));
    }
  }

  Future<void> _onFetchMoreMovies(FetchMoreMovies event, Emitter<MovieState> emit) async {
    try {
      if(!(await _connectivityAvailable())){
        emit(MovieLoadError("No internet connection. Please check your network and try again."));
      }

      List<Movie> moreMovies = [];
      moreMovies = await locator<MovieRepository>().getMovies(page: currentPage + 1);
      loadedMovies.addAll(moreMovies);
      currentPage++;

      emit(MovieLoaded(loadedMovies, false));
    } catch (e) {
      emit(MovieLoadError(e.toString()));
    }
  }

  Future<void> _onOnlyShowFavoriteMovies(FavoriteMoviesToggle event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      if(event.onlyFavorites){
        List<Movie> movies = await locator<HiveService>().getFavoriteMovies();
        emit(MovieLoaded(movies, true));
      } else {
        emit(MovieLoaded(loadedMovies, false));
      }
    } catch (e) {
      emit(MovieLoadError(e.toString()));
    }
  }
}
