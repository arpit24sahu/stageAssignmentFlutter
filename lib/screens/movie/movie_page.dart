import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/movie_favorite_bloc/movie_favorite_bloc.dart';
import '../../bloc/movie_favorite_bloc/movie_favorite_event.dart';
import '../../bloc/movie_favorite_bloc/movie_favorite_state.dart';
import '../../constants.dart';
import '../../data/models/movie.dart';

class MoviePage extends StatelessWidget {
  final Movie movie;

  const MoviePage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final bloc = context.read<MovieCardFavoriteBloc>();

  return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: [
          IconButton(
              icon: Icon(Icons.share),
            onPressed: (){

            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            if (movie.backdropPath != null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        '${TmdbApi.imageBaseUrl}/${movie.backdropPath}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  '${TmdbApi.imageBaseUrl}/${movie.posterPath}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title ?? "Untitled",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Release Date
                              if (movie.releaseDate != null)
                                Text(
                                  "Release Date: ${movie.releaseDate}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              Text(
                                "Average Rating: ${movie.voteAverage}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Favorite Icon
                      BlocBuilder<MovieCardFavoriteBloc, MovieCardFavoriteState>(
                        builder: (context, state) {
                          bool isFavorite = false;

                          if (state is MovieCardFavoriteStatus) {
                            isFavorite = state.isFavorite;
                          }

                          return IconButton(
                            onPressed: () {
                              bloc.add(ToggleFavoriteStatus(movie));
                            },
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                              size: 30.0,
                            ),
                          );
                        },
                      ),

                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(thickness: 2,),
                  // Overview
                  if (movie.overview != null)
                    Text(
                      movie.overview!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 2,),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
