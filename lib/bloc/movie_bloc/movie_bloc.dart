import 'package:bloc/bloc.dart';

import '../../data/api/movie_api.dart';
import '../../data/repositories/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await MovieRepository.getMovies(page: event.page);
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieLoadError('Failed to load movies: ${e.toString()}'));
    }
  }
}
