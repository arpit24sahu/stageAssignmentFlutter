import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/movie_bloc/movie_bloc.dart';
import '../../bloc/movie_bloc/movie_event.dart';
import '../../bloc/movie_bloc/movie_state.dart';
import '../../data/models/movie.dart';
import '../movie/movie_list.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController searchTermController = TextEditingController();

  final ValueNotifier<String> searchTermNotifier = ValueNotifier<String>('');

  bool showMoreMoviesButton(bool onlyFavMovies, String searchTerm, List<Movie> filteredMovies){
    return (!onlyFavMovies) && searchTerm.isEmpty && filteredMovies.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        centerTitle: false,
        actions: [
          // This BlocBuilder is for Building the "Only Favorites" Toggle.
          // It is turned on only when the movies are loaded and User has chosen to view the favorite movies only
          BlocBuilder<MovieBloc, MovieState>(
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
                      context.read<MovieBloc>().add(FavoriteMoviesToggle(value));
                    },
                  )
                ],
              );
            },
          )
        ],
        bottom: AppBar(
          automaticallyImplyLeading: false,
          title: TextField(
            controller: searchTermController,
            onChanged: (String value){
              searchTermNotifier.value = searchTermController.text;
            },
            decoration: const InputDecoration(
                hintText: "Search",
              border: OutlineInputBorder()
            ),
          )
        ),
      ),
      // This is responsible for rendering the main body of the App
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded) {
            // To dynamically change the value of searchTerm, we use a ValueListenableBuilder
            // based on the value of searchTerm, we filter our results
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
                    key: const ValueKey("MovieListColumn"),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MovieList(movies: filteredMovies),
                      const SizedBox(
                        height: 16,
                      ),

                      /// Give option to load more movies if "Only Favorites" is deselected, searchBox is Empty and there are already some movies present
                      if(showMoreMoviesButton(state.onlyFavoriteMovies, searchTermController.text, filteredMovies)) ElevatedButton(
                        onPressed: (){
                          context.read<MovieBloc>().add(FetchMoreMovies());
                        },
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
                      context.read<MovieBloc>().add(FetchMovies());
                    },
                    child: const Text('Retry?'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MovieBloc>().add(FavoriteMoviesToggle(true));
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
    );
  }
}

