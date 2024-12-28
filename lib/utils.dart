import 'package:flutter_dotenv/flutter_dotenv.dart';

// gets value from .env File
String getDotenv(String key) => dotenv.get(key, fallback: "");
