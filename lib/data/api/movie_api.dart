import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instabot/constants.dart';
import 'package:instabot/utils.dart';

class MovieApi {
  static const  String _baseUrl = TmdbApi.baseUrl;
  static const String _trendingMoviesEndpoint = TmdbApi.trendingMoviesEndpoint;
  static final String _apiKey = getDotenv(DotEnvKeys.tmdbApiKey);
  static final String _apiToken = getDotenv(DotEnvKeys.tmdbApiAccessToken);

  static _buildApiEndpoint(String endpoint, int page){
    return "$_baseUrl$endpoint?page=$page&api_key=$_apiKey";
  }

  static Future<Map<String, dynamic>> getTrendingMovies(int page) async {
    final endpoint = _buildApiEndpoint(_trendingMoviesEndpoint, page);
    final url = Uri.parse(endpoint);

    try {

      final response = await http.get(url,
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Uh oh! The request failed with Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Uh oh! The server request failed. Can you recheck your Internet Connection?');
    }
  }
}
