import 'package:flutter/material.dart';
import 'package:instabot/screens/movie_card.dart';
import '../data/models/movie.dart';

class MovieList extends StatefulWidget {
  final List<Movie> movies;
  const MovieList({super.key, required this.movies});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300, childAspectRatio: 0.5),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: widget.movies.length,
      itemBuilder: (BuildContext context, int index){
        Movie movie = widget.movies[index];
        return MovieCard(movie: movie);
      },
    );
  }
}
