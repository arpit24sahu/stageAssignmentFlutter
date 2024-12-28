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
  bool onlyFavorites = false;
  int currentPage = 1;

  void onFavToggleChange(bool value){
    _movieBloc.add(FetchMovies(value, 1));
  }

  void onLoadMoreMovies(){
    currentPage++;
    _movieBloc.add(FetchMoreMovies(currentPage));
  }

  @override
  void initState() {
    super.initState();
    _movieBloc.add(FetchMovies(onlyFavorites, 1));
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
          FavoritesToggle(onChange: onFavToggleChange, initialValue: onlyFavorites,)
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
        create: (_) => _movieBloc,
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
                        if(searchTerm.isEmpty && state.movies.isNotEmpty && (!onlyFavorites))
                          ElevatedButton(
                            onPressed: (){
                              // Todo
                              // Implement last page functionality and fix visibility of this button
                              onLoadMoreMovies();
                            },
                            child: Text("Load More Movies"),
                          )

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
                        _movieBloc.add(FetchMovies(onlyFavorites, 1));
                      },
                      child: const Text('Retry?'),
                    ),
                    const SizedBox(height: 10),
                    if(!onlyFavorites) ElevatedButton(
                      onPressed: () {
                        _movieBloc.add(FetchMovies(onlyFavorites, 1));
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

class FavoritesToggle extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onChange;
  const FavoritesToggle({super.key, required this.initialValue, required this.onChange});

  @override
  State<FavoritesToggle> createState() => _FavoritesToggleState();
}

class _FavoritesToggleState extends State<FavoritesToggle> {

  bool isFav = false;

  void initialize(){
    setState(() {
      isFav = widget.initialValue;
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Only Favorites "),
        Switch(
          value: isFav,
          onChanged: (bool value){
            widget.onChange(value);
            setState(() {
              isFav = value;
            });
          },
        )
      ],
    );
  }
}
