import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:instabot/data/service/hive_service.dart';
import 'package:instabot/screens/homepage/homepage.dart';

import 'bloc/movie_bloc/movie_bloc.dart';
import 'constants.dart';
import 'data/service/hive_favorite_service.dart';

void main() async {
  await initializeApp();
  runApp(MyApp());
}

Future<void> initializeApp()async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initializeHive();

  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MovieBloc _movieBloc = MovieBloc(
      connectivity: connectivity,
      movieRepository: movieRepository,
      hiveFavoriteService: HiveFavoriteService(
          favoriteBox: hiveService.favoriteBox()
      )
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => _movieBloc,
        child: HomePage(movieBloc: _movieBloc,),
      ),
    );
  }
}


