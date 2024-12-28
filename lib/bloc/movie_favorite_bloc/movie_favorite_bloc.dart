import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:instabot/data/service/constants.dart';

import 'movie_favorite_event.dart';
import 'movie_favorite_state.dart';

class MovieCardFavoriteBloc
    extends Bloc<MovieCardFavoriteEvent, MovieCardFavoriteState> {
  final Box favoriteBox = Hive.box(HiveBoxNames.favoriteMovies.name);

  MovieCardFavoriteBloc() : super(MovieCardFavoriteInitial()) {
    on<CheckFavoriteStatus>(_onCheckFavoriteStatus);
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
  }

  Future<void> _onCheckFavoriteStatus(
      CheckFavoriteStatus event, Emitter<MovieCardFavoriteState> emit) async {
    try {
      emit(MovieCardFavoriteLoading());
      final isFavorite = favoriteBox.containsKey(event.movieId);
      emit(MovieCardFavoriteStatus(isFavorite));
    } catch (e) {
      emit(MovieCardFavoriteError("Failed to check favorite status"));
    }
  }

  Future<void> _onToggleFavoriteStatus(
      ToggleFavoriteStatus event, Emitter<MovieCardFavoriteState> emit) async {
    try {
      emit(MovieCardFavoriteLoading());
      final isFavorite = favoriteBox.containsKey(event.movie.id.toString());

      if (isFavorite) {
        favoriteBox.delete(event.movie.id.toString());
        emit(MovieCardFavoriteStatus(false));
      } else {
        favoriteBox.put(event.movie.id.toString(), event.movie.toJson());
        emit(MovieCardFavoriteStatus(true));
      }
    } catch (e) {
      emit(MovieCardFavoriteError("Failed to toggle favorite status"));
    }
  }
}