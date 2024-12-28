import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:instabot/data/service/constants.dart';

import '../models/movie.dart';


class HiveService{
  static Future<void> initializeHive()async{
    await Hive.initFlutter();

    await Hive.openBox(HiveBoxNames.favoriteMovies.name);
  }


  static Future<List<Movie>> getFavoriteMovies() async {
    var box = await Hive.openBox(HiveBoxNames.favoriteMovies.name);
    var movieIds = box.keys;
    List<Movie> favoriteMovies = [];

    for (var movieId in movieIds) {
      var movieJson = box.get(movieId);
      if (movieJson != null) {
        favoriteMovies.add(Movie.fromJson(movieJson.cast<String, dynamic>()));
      }
    }
    return favoriteMovies;
  }
}