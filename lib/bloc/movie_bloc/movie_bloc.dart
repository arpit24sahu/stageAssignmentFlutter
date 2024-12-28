import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:instabot/data/service/hive_service.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  List<Movie> loadedMovies = [];

  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<FetchMoreMovies>(_onFetchMoreMovies);
    on<OnlyShowFavoriteMovies>(_onOnlyShowFavoriteMovies);
  }

  static Future<bool> _connectivityAvailable() async {
    List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();
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

      loadedMovies = await MovieRepository.getMovies(page: event.page);
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
      moreMovies = await MovieRepository.getMovies(page: event.page);
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
        List<Movie> movies = await HiveService.getFavoriteMovies();
        emit(MovieLoaded(movies, true));
      } else {
        emit(MovieLoaded(loadedMovies, false));
      }
    } catch (e) {
      emit(MovieLoadError(e.toString()));
    }
  }
}
