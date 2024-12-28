import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/movie_bloc/movie_bloc.dart';
import '../../bloc/movie_bloc/movie_event.dart';
import '../../bloc/movie_bloc/movie_state.dart';
import '../movie_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieBloc _movieBloc = MovieBloc();

  @override
  void initState() {
    super.initState();
    _movieBloc.add(FetchMovies(1));
  }

  @override
  void dispose() {
    _movieBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        bottom: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Favorites"),
          centerTitle: false,
          actions: [
            Switch(
              value: false,
              onChanged: (bool value){

              },
            )
          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => _movieBloc,
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              return MovieList(movies: state.movies);
            } else if (state is MovieLoadError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.error,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _movieBloc.add(FetchMovies(1));
                      },
                      child: const Text('Retry?'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Welcome to the Movie App'));
          },
        ),
      ),
    );
  }
}