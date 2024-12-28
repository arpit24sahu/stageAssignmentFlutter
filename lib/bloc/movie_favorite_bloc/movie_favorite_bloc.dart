import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import '../../data/service/hive_service.dart';
import 'movie_favorite_event.dart';
import 'movie_favorite_state.dart';

class MovieCardFavoriteBloc
    extends Bloc<MovieCardFavoriteEvent, MovieCardFavoriteState> {
  final Box favoriteBox = Hive.box(HiveBoxNames.favoriteMovies.name);
  final String movieId;

  MovieCardFavoriteBloc({required this.movieId}) : super(MovieCardFavoriteInitial()) {
    on<CheckFavoriteStatus>(_onCheckFavoriteStatus);
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
  }

  Future<void> _onCheckFavoriteStatus(
      CheckFavoriteStatus event, Emitter<MovieCardFavoriteState> emit) async {
    try {
      emit(MovieCardFavoriteLoading());
      final isFavorite = favoriteBox.containsKey(movieId);
      emit(MovieCardFavoriteStatus(isFavorite));
    } catch (e) {
      emit(MovieCardFavoriteError("Failed to check favorite status"));
    }
  }

  Future<void> _onToggleFavoriteStatus(
      ToggleFavoriteStatus event, Emitter<MovieCardFavoriteState> emit) async {
    try {
      emit(MovieCardFavoriteLoading());
      final isFavorite = favoriteBox.containsKey(movieId);

      if (isFavorite) {
        favoriteBox.delete(movieId);
        emit(MovieCardFavoriteStatus(false));
      } else {
        favoriteBox.put(movieId, event.movie.toJson());
        emit(MovieCardFavoriteStatus(true));
      }
    } catch (e) {
      emit(MovieCardFavoriteError("Failed to toggle favorite status"));
    }
  }
}