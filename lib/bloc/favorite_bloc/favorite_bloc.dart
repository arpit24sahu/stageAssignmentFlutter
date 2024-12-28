import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import '../../data/models/movie.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final Box favoriteBox;

  FavoriteBloc(this.favoriteBox) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLoading());
      final favorites = favoriteBox.values
          .map((json) => Movie.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      emit(FavoriteSuccess(favorites));
    } catch (e) {
      emit(FavoriteFailure("Failed to load favorites: ${e.toString()}"));
    }
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event, Emitter<FavoriteState> emit) async {
    try {
      favoriteBox.put(event.movie.id, event.movie.toJson());
      final favorites = favoriteBox.values
          .map((json) => Movie.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      emit(FavoriteSuccess(favorites));
    } catch (e) {
      emit(FavoriteFailure("Failed to add to favorites: ${e.toString()}"));
    }
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavorites event, Emitter<FavoriteState> emit) async {
    try {
      favoriteBox.delete(event.movieId);
      final favorites = favoriteBox.values
          .map((json) => Movie.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      emit(FavoriteSuccess(favorites));
    } catch (e) {
      emit(FavoriteFailure("Failed to remove from favorites: ${e.toString()}"));
    }
  }
}