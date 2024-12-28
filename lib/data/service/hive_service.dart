import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:instabot/data/service/constants.dart';


class HiveService{
  static Future<void> initializeHive()async{
    await Hive.initFlutter();

    await Hive.openBox(HiveBoxNames.favoriteMovies.name);
  }
}