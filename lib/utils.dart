import 'package:flutter_dotenv/flutter_dotenv.dart';

String getDotenv(String key){
  return dotenv.get(key, fallback: "");
}