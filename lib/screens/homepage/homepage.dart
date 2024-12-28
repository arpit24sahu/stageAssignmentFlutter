import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/movie_bloc/movie_bloc.dart';
import '../../bloc/movie_bloc/movie_event.dart';
import '../../bloc/movie_bloc/movie_state.dart';
import '../../data/models/movie.dart';
import '../movie/movie_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieBloc _movieBloc = MovieBloc();

  TextEditingController searchTermController = TextEditingController();
  final ValueNotifier<String> searchTermNotifier = ValueNotifier<String>('');

  int currentPage = 1;

  void onLoadMoreMovies(){
    currentPage++;
    _movieBloc.add(FetchMoreMovies(currentPage));
  }

  @override
  void initState() {
    super.initState();
    _movieBloc.add(FetchMovies(1));
    searchTermController.addListener(() {
      searchTermNotifier.value = searchTermController.text;
    });
  }

  @override
  void dispose() {
    _movieBloc.close();
    searchTermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        centerTitle: false,
        actions: [
          BlocProvider(
            create: (context) => _movieBloc,
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state){
                bool turnedOn = false;
                if(state is MovieLoaded && state.onlyFavoriteMovies){
                  turnedOn = true;
                }
                return Row(
                  children: [
                    const Text("Only Favorites "),
                    Switch(
                      value: turnedOn,
                      onChanged: (bool value){
                        _movieBloc.add(OnlyShowFavoriteMovies(value));
                      },
                    )
                  ],
                );
              },
            ),
          )

        ],
        bottom: AppBar(
          automaticallyImplyLeading: false,
          title: TextField(
            controller: searchTermController,
            decoration: const InputDecoration(
                hintText: "Search",
              border: OutlineInputBorder()
            ),
          )
        ),
      ),
      body: BlocProvider(
        create: (context) => _movieBloc,
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              return ValueListenableBuilder<String>(
                valueListenable: searchTermNotifier,
                builder: (context, searchTerm, _) {
                  // Filter movies based on search term
                  List<Movie> filteredMovies = state.movies.where((movie) {
                    return (movie.title ?? "").toLowerCase().contains(searchTerm.toLowerCase());
                  }).toList();

                  // Return the updated MovieList
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MovieList(movies: filteredMovies),
                        const SizedBox(
                          height: 16,
                        ),

                        /// Give option to load more movies if "Only Favorites" is deselected, searchBox is Empty and there are already some movies present
                        if((!state.onlyFavoriteMovies) && searchTermController.text.isEmpty && filteredMovies.isNotEmpty) ElevatedButton(
                          onPressed: onLoadMoreMovies,
                          child: const Text("Load More Movies"),
                        ),
                        if(filteredMovies.isEmpty) ...[
                          if(searchTermController.text.isNotEmpty) const Center(child: Text("No Movies met your search Criteria"))
                          else const Center(child: Text("No Movies Found"))
                        ],
                      ],
                    ),
                  );
                },
              );
              // return MovieList(movies: state.movies);
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _movieBloc.add(OnlyShowFavoriteMovies(true));
                      },
                      child: const Text('View Favorite Movies instead?'),
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

