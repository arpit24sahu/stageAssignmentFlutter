import 'package:bloc/bloc.dart';
import 'package:instabot/data/service/hive_service.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  List<Movie> movies = [];

  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<FetchMoreMovies>(_onFetchMoreMovies);
  }

  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      if(event.onlyFavorites){
        movies = await HiveService.getFavoriteMovies();
      } else {
        movies = await MovieRepository.getMovies(page: event.page);
      }
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieLoadError('Failed to load movies: ${e.toString()}'));
    }
  }

  Future<void> _onFetchMoreMovies(FetchMoreMovies event, Emitter<MovieState> emit) async {
    try {
      List<Movie> moreMovies = [];
      moreMovies = await MovieRepository.getMovies(page: event.page);
      movies.addAll(moreMovies);
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieLoadError('Failed to load movies: ${e.toString()}'));
    }
  }
}
