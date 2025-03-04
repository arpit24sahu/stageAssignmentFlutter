import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:instabot/data/service/hive_service.dart';
import 'package:instabot/screens/homepage/homepage.dart';
import 'bloc/movie_bloc/movie_bloc.dart';
import 'bloc/movie_bloc/movie_event.dart';
import 'locator.dart';

void main() async {
  await initializeApp();
  runApp(const MyApp());
}

Future<void> initializeApp()async{
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await HiveService.initializeHive();

  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        // create: (context) => MovieBloc(
        //     connectivity: connectivity,
        //     movieRepository: locator<MovieRepository>(),
        //     hiveFavoriteService: HiveFavoriteService(
        //         favoriteBox: hiveService.favoriteBox()
        //     )
        // )..add(FetchMovies()),
        create: (context) => MovieBloc()..add(FetchMovies()),
        child: HomePage(),
      ),
    );
  }
}


