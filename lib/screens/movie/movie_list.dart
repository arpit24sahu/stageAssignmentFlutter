import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instabot/constants.dart';
import 'package:instabot/data/service/hive_service.dart';
import 'package:instabot/screens/movie/movie_card.dart';
import '../../bloc/movie_favorite_bloc/movie_favorite_bloc.dart';
import '../../bloc/movie_favorite_bloc/movie_favorite_event.dart';
import '../../data/models/movie.dart';
import '../../data/service/hive_favorite_service.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieFavoriteBloc(
          hiveFavoriteService: HiveFavoriteService(
              favoriteBox: hiveService.favoriteBox()
          )
      )..add(LoadFavoriteMovies()),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300, childAspectRatio: 0.5),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index){
          Movie movie = movies[index];
          return MovieCard(
            key: ValueKey(movie.id),
              movie: movie
          );
        },
      ),
    );
  }
}
