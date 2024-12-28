import 'package:flutter/material.dart';

import '../../data/models/movie.dart';

class MoviePage extends StatelessWidget {
  final Movie movie;
  const MoviePage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Title: ${movie.id}"),
        Text("Title: ${movie.title}"),
      ],
    );
  }
}
