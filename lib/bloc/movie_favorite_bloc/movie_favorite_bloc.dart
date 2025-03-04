import 'package:bloc/bloc.dart';
import '../../data/models/movie.dart';
import '../../data/service/hive_service.dart';
import '../../locator.dart';
import 'movie_favorite_event.dart';
import 'movie_favorite_state.dart';


class MovieFavoriteBloc extends Bloc<MovieFavoriteEvent, MovieFavoriteState> {
  // final Box favoriteBox;
  List<Movie> favoriteMovies = [];
  String? currentMovieId;

  MovieFavoriteBloc() : super(MovieFavoritesLoading()) {
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
    on<MovieFavoriteToggle>(_onMovieFavoriteToggle);
  }

  Future<void> _onLoadFavoriteMovies(LoadFavoriteMovies event, Emitter<MovieFavoriteState> emit)async{
    emit(MovieFavoritesLoading());
    try {
      List<Movie> movies = await locator<HiveService>().getFavoriteMovies();
      emit(MovieFavoritesLoaded(favoriteMovies: movies, ));
    } catch(e){
      emit(MovieFavoritesError(errorMessage: e.toString()));
    }
  }
  Future<void> _onMovieFavoriteToggle(MovieFavoriteToggle event, Emitter<MovieFavoriteState> emit)async{
    try {
      final isFavorite = locator<HiveService>().favoriteBox.containsKey(event.movie.id);

      if (isFavorite) {
        locator<HiveService>().favoriteBox.delete(event.movie.id);
        favoriteMovies.removeWhere((movie) => movie.id == event.movie.id);
      } else {
        locator<HiveService>().favoriteBox.put(event.movie.id, event.movie.toJson());
        favoriteMovies.add(event.movie);
      }
      emit(MovieFavoritesLoaded(favoriteMovies: favoriteMovies, movie: event.movie));
    } catch(e){
      emit(MovieFavoritesError(errorMessage: e.toString()));
    }
  }
}


//
// class MovieCardFavoriteBloc
//     extends Bloc<MovieCardFavoriteEvent, MovieCardFavoriteState> {
//   final Box favoriteBox = Hive.box(HiveBoxNames.favoriteMovies.name);
//   final String movieId;
//
//   MovieCardFavoriteBloc({required this.movieId}) : super(MovieCardFavoriteInitial()) {
//     on<CheckFavoriteStatus>(_onCheckFavoriteStatus);
//     on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
//   }
//
//   Future<void> _onCheckFavoriteStatus(
//       CheckFavoriteStatus event, Emitter<MovieCardFavoriteState> emit) async {
//     try {
//       emit(MovieCardFavoriteLoading());
//       final isFavorite = favoriteBox.containsKey(movieId);
//       emit(MovieCardFavoriteStatus(isFavorite));
//     } catch (e) {
//       emit(MovieCardFavoriteError("Failed to check favorite status"));
//     }
//   }
//
//   Future<void> _onToggleFavoriteStatus(
//       ToggleFavoriteStatus event, Emitter<MovieCardFavoriteState> emit) async {
//     try {
//       emit(MovieCardFavoriteLoading());
//       final isFavorite = favoriteBox.containsKey(movieId);
//
//       if (isFavorite) {
//         favoriteBox.delete(movieId);
//         emit(MovieCardFavoriteStatus(false));
//       } else {
//         favoriteBox.put(movieId, event.movie.toJson());
//         emit(MovieCardFavoriteStatus(true));
//       }
//     } catch (e) {
//       emit(MovieCardFavoriteError("Failed to toggle favorite status"));
//     }
//   }
// }