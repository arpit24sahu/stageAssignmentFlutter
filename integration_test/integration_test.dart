import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:instabot/bloc/movie_bloc/movie_event.dart';
import 'package:instabot/bloc/movie_bloc/movie_state.dart';
import 'package:instabot/data/service/hive_favorite_service.dart';
import 'package:instabot/data/service/hive_service.dart';
import 'package:integration_test/integration_test.dart';
import 'package:instabot/bloc/movie_bloc/movie_bloc.dart';
import 'package:instabot/data/models/movie.dart';
import 'package:instabot/data/repositories/movie_repository.dart';
import 'package:instabot/main.dart' as app;
import 'package:instabot/screens/homepage/homepage.dart' as homepage;
import 'package:instabot/screens/homepage/homepage.dart';
import 'package:instabot/screens/movie/movie_card.dart';
import 'package:instabot/screens/movie/movie_list.dart';
import 'package:instabot/screens/movie/movie_page.dart';
import 'package:mocktail/mocktail.dart';
import 'integration_test.dart';

// Mock classes
class MockMovieRepository extends Mock implements MovieRepository {}
class MockConnectivity extends Mock implements Connectivity {}
class MockHiveFavoriteService extends Mock implements HiveFavoriteService {}
class MockHiveService extends Mock implements HiveService {}
class MockBox extends Mock implements Box {}

List<Movie> mockMovies = [
  Movie(id: "1", title: "Apple", ),
  Movie(id: "2", title: "Banana", ),
  Movie(id: "3", title: "Orange", ),
  Movie(id: "4", title: "Grapes1", ),
  Movie(id: "5", title: "Grapes2", ),
  Movie(id: "6", title: "Grapes3", ),
];

List<Movie> mockMoreMovies = [
  Movie(id: "7", title: "Dog", ),
  Movie(id: "8", title: "Cat", ),
  Movie(id: "9", title: "Lion", ),
  Movie(id: "10", title: "Giraffe1", ),
  Movie(id: "11", title: "Giraffe2", ),
  Movie(id: "12", title: "Kangaroo", ),
];


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(()async{
    await HiveService.initializeHive();
    await Hive.openBox(HiveBoxNames.favoriteMovies.name);
  });

  group('end-to-end test', () {
    testWidgets('app launches', (tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();
      expect(find.byType(app.MyApp), findsOneWidget);
    });

    testWidgets('homepage displays correctly', (tester) async {
      MockMovieRepository mockMovieRepository  = MockMovieRepository();
      MockConnectivity mockConnectivity  = MockConnectivity();
      MockHiveFavoriteService mockHiveFavoriteService  = MockHiveFavoriteService();
      final mockMovieBloc = MovieBloc(
          movieRepository: mockMovieRepository,
          connectivity: mockConnectivity,
          hiveFavoriteService: mockHiveFavoriteService
      );
      Widget widget = MaterialApp(
        home: BlocProvider(create: (context) => mockMovieBloc, child: HomePage()),
      );
      when(()=> mockMovieRepository.getMovies()).thenAnswer((_) async=> mockMovies);
      when(()=> mockMovieRepository.getMovies(page: any(named: 'page'))).thenAnswer((_) async=> mockMovies);
      when(()=> mockConnectivity.checkConnectivity()).thenAnswer((_) async=> [ConnectivityResult.mobile]);
      when(()=> mockHiveFavoriteService.getFavoriteMovies()).thenAnswer((_) async=> mockMovies);

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      Future.delayed(const Duration(milliseconds: 5000));
      expect(find.byType(MovieList), findsOneWidget);

      // homepage search functionality
      final finder = find.byType(TextField);
      expect(finder, findsOneWidget);
      await tester.enterText(finder, 'apple');
      await tester.pumpAndSettle();
      final movieCardFinder = find.byType(MovieCard);
      expect(movieCardFinder, findsOneWidget);
      await tester.enterText(finder, 'grapes');
      await tester.pumpAndSettle();
      expect(movieCardFinder, findsNWidgets(3));
      await tester.enterText(finder, 'emptyMovie');
      await tester.pumpAndSettle();
      expect(movieCardFinder, findsNothing);
    });

    testWidgets('homepage load more movies', (tester) async {
      MockMovieRepository mockMovieRepository  = MockMovieRepository();
      MockConnectivity mockConnectivity  = MockConnectivity();
      MockHiveFavoriteService mockHiveFavoriteService  = MockHiveFavoriteService();
      final mockMovieBloc = MovieBloc(
          movieRepository: mockMovieRepository,
          connectivity: mockConnectivity,
          hiveFavoriteService: mockHiveFavoriteService
      );
      Widget widget = MaterialApp(
        home: BlocProvider(create: (context) => mockMovieBloc, child: HomePage()),
      );

      when(()=> mockMovieRepository.getMovies(page: any(named: 'page'))).thenAnswer((_) async=> mockMoreMovies);
      when(()=> mockMovieRepository.getMovies()).thenAnswer((_) async=> mockMovies);
      when(()=> mockMovieRepository.getMovies(page: 1)).thenAnswer((_) async=> mockMovies);
      when(()=> mockConnectivity.checkConnectivity()).thenAnswer((_) async=> [ConnectivityResult.mobile]);
      when(()=> mockHiveFavoriteService.getFavoriteMovies()).thenAnswer((_) async=> mockMovies);
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final movieCardFinder = find.byType(MovieCard);
      expect(movieCardFinder, findsNWidgets(6));
      final loadMoreButtonFinder = find.byType(ElevatedButton);
      final buttonOffset = tester.getCenter(loadMoreButtonFinder);
      await tester.tapAt(buttonOffset);
      await tester.pumpAndSettle();
      await tester.tap(loadMoreButtonFinder);
      await tester.pumpAndSettle();
      expect(movieCardFinder, findsNWidgets(12));
    });

    testWidgets('movie_list displays correctly', (tester) async {
      await tester.pumpWidget(MovieList(movies: [Movie(id: "1", title: 'Test Movie', posterPath: '', overview: '', releaseDate: '')]));
      await tester.pumpAndSettle();
      expect(find.byType(MovieList), findsOneWidget);
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('movie_card displays correctly', (tester) async {
      await tester.pumpWidget(MovieCard(movie: Movie(id: "1", title: 'Test Movie', posterPath: '', overview: '', releaseDate: '')));
      await tester.pumpAndSettle();
      expect(find.byType(MovieCard), findsOneWidget);
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('movie_page displays correctly', (tester) async {
      await tester.pumpWidget(MoviePage(movie: Movie(id: "1", title: 'Test Movie', posterPath: '', overview: '', releaseDate: '')));
      await tester.pumpAndSettle();
      expect(find.byType(MoviePage), findsOneWidget);
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('homepage handles error correctly', (tester) async {
      final movieBloc = MovieBloc(movieRepository: MockMovieRepository(), connectivity: MockConnectivity(), hiveFavoriteService: MockHiveFavoriteService());
      when(()=> movieBloc.movieRepository.getMovies(page: 1)).thenThrow(Exception('Network error'));
      await tester.pumpWidget(BlocProvider.value(value: movieBloc, child: HomePage()));
      await tester.pumpAndSettle();
      expect(find.text('Network error'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2)); // Retry and View Favorites buttons
    });
  });

  group('MovieBloc', () {
    final mockMovieRepository = MockMovieRepository();
    final mockConnectivity = MockConnectivity();
    final mockHiveService = MockHiveFavoriteService();

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoaded] when FetchMovies event is added',
      build: () => MovieBloc(movieRepository: mockMovieRepository, connectivity: mockConnectivity, hiveFavoriteService: mockHiveService),
      act: (bloc) => bloc.add(FetchMovies()),
      expect: () => [isA<MovieLoaded>()],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoaded] when FetchMoreMovies event is added',
      build: () => MovieBloc(movieRepository: mockMovieRepository, connectivity: mockConnectivity, hiveFavoriteService: mockHiveService),
      act: (bloc) => bloc.add(FetchMoreMovies()),
      expect: () => [isA<MovieLoaded>()],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoaded] with favorite movies when OnlyShowFavoriteMovies event is added with onlyFavorites true',
      build: () => MovieBloc(movieRepository: mockMovieRepository, connectivity: mockConnectivity, hiveFavoriteService: mockHiveService),
      act: (bloc) => bloc.add(FavoriteMoviesToggle(true)),
      expect: () => [isA<MovieLoaded>()],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoaded] with all movies when OnlyShowFavoriteMovies event is added with onlyFavorites false',
      build: () => MovieBloc(movieRepository: mockMovieRepository, connectivity: mockConnectivity, hiveFavoriteService: mockHiveService),
      act: (bloc) => bloc.add(FavoriteMoviesToggle (false)),
      expect: () => [isA<MovieLoaded>()],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoadError] when FetchMovies event fails',
      build: () => MovieBloc(movieRepository: mockMovieRepository, connectivity: mockConnectivity, hiveFavoriteService: mockHiveService),
      act: (bloc) => bloc.add(FetchMovies()),
      expect: () => [isA<MovieLoadError>()],
      setUp: () {
        when(() => mockMovieRepository.getMovies(page: 1)).thenThrow(Exception('Network error'));
      },
    );
  });
}
