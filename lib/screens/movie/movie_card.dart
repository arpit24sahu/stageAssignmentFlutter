import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:instabot/screens/movie/movie_page.dart';

import '../../bloc/movie_favorite_bloc/movie_favorite_bloc.dart';
import '../../bloc/movie_favorite_bloc/movie_favorite_event.dart';
import '../../bloc/movie_favorite_bloc/movie_favorite_state.dart';
import '../../constants.dart';
import '../../data/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    print("Rebuilding Movie Card: ${movie.title}");
    return InkWell(
      onTap: () {
        // When movie card is tapped, open the MoviePage which shows movie details
        Navigator.push(context,
            MaterialPageRoute(
              builder: (newContext) => BlocProvider.value(
                  value: context.read<MovieFavoriteBloc>(),
                  child: MoviePage(movie: movie)
              ),
            )
        );
      },
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Poster Image
              movie.posterPath != null
                  ? ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
                child: Image.network(
                  '${TmdbApi.imageBaseUrl}/${movie.posterPath}',
                  // height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              )
                  : Container(
                height: 600,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        movie.title??"",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BlocBuilder<MovieFavoriteBloc, MovieFavoriteState>(
                        buildWhen: (previous, current){
                          if(current is MovieFavoritesLoaded){
                            if(current.movie==null) {
                              return true;
                            } else if(current.movie!.id == movie.id){
                              return true;
                            } else {
                              return false;
                            }
                          }
                          return true;
                        },
                        builder: (context, state) {
                          // print("Build movie card fav button: ${movie.title}");
                          bool isFavorite = false;
                          if (state is MovieFavoritesLoaded) {
                            isFavorite = state.favoriteMovies.map((movie) => movie.id).contains(movie.id);
                          }

                          return IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {
                              // Toggle Fav movie when icon is clicked
                              context.read<MovieFavoriteBloc>().add(MovieFavoriteToggle(movie: movie));
                            },
                          );
                        }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
