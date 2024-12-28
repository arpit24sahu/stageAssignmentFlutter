import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:instabot/data/service/hive_service.dart';
import 'package:instabot/screens/homepage/homepage.dart';

void main() async {
  await initializeApp();
  runApp(const MyApp());
}

Future<void> initializeApp()async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initializeHive();

  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


