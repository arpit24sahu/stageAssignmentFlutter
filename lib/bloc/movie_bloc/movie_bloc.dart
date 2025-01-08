import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';
import '../../data/service/hive_favorite_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;
  final Connectivity connectivity;
  final HiveFavoriteService hiveFavoriteService;

  List<Movie> loadedMovies = [];

  MovieBloc({required this.movieRepository, required this.connectivity, required this.hiveFavoriteService}) : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<FetchMoreMovies>(_onFetchMoreMovies);
    on<OnlyShowFavoriteMovies>(_onOnlyShowFavoriteMovies);
  }

  Future<bool> _connectivityAvailable() async {
    List<ConnectivityResult> connectivityResults = await connectivity.checkConnectivity();
    print(connectivityResults);
    if(connectivityResults.contains(ConnectivityResult.wifi)
        || connectivityResults.contains(ConnectivityResult.mobile)){
      return true;
    }
    return false;
  }

  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      if(!(await _connectivityAvailable())){
        emit(MovieLoadError("No internet connection. Please check your network and try again."));
        return;
      }

      loadedMovies = await movieRepository.getMovies(page: event.page);
      emit(MovieLoaded(loadedMovies, false));
    } catch (e) {
      emit(MovieLoadError(e.toString()));
    }
  }

  // // Old function without the Network Connectivity Check
  // Future<void> _onFetchMovies2(FetchMovies event, Emitter<MovieState> emit) async {
  //   emit(MovieLoading());
  //   try {
  //     loadedMovies = await MovieRepository.getMovies(page: event.page);
  //     emit(MovieLoaded(loadedMovies, false));
  //   } catch (e) {
  //     emit(MovieLoadError(e.toString()));
  //   }
  // }

  Future<void> _onFetchMoreMovies(FetchMoreMovies event, Emitter<MovieState> emit) async {
    try {
      if(!(await _connectivityAvailable())){
        emit(MovieLoadError("No internet connection. Please check your network and try again."));
      }

      List<Movie> moreMovies = [];
      moreMovies = await movieRepository.getMovies(page: event.page);
      loadedMovies.addAll(moreMovies);

      emit(MovieLoaded(loadedMovies, false));
    } catch (e) {
      emit(MovieLoadError(e.toString()));
    }
  }

  // // Old function without the Network Connectivity Check
  // Future<void> _onFetchMoreMovies2(FetchMoreMovies event, Emitter<MovieState> emit) async {
  //   try {
  //     List<Movie> moreMovies = [];
  //     moreMovies = await MovieRepository.getMovies(page: event.page);
  //     loadedMovies.addAll(moreMovies);
  //     emit(MovieLoaded(loadedMovies, false));
  //   } catch (e) {
  //     emit(MovieLoadError(e.toString()));
  //   }
  // }

  Future<void> _onOnlyShowFavoriteMovies(OnlyShowFavoriteMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      if(event.onlyFavorites){
        List<Movie> movies = await hiveFavoriteService.getFavoriteMovies();
        emit(MovieLoaded(movies, true));
      } else {
        emit(MovieLoaded(loadedMovies, false));
      }
    } catch (e) {
      emit(MovieLoadError(e.toString()));
    }
  }
}
