import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instabot/constants.dart';
import 'package:instabot/utils.dart';

class MovieApi {
  static const  String _baseUrl = TmdbApi.baseUrl;
  static const String _trendingMoviesEndpoint = TmdbApi.trendingMoviesEndpoint;
  static final String _apiKey = getDotenv(DotEnvKeys.tmdbApiKey); // Pass the API key during initialization.

  static _buildApiEndpoint(String endpoint, int page){
    return "$_baseUrl$endpoint?page=$page&api_key=$_apiKey";
  }

  /// Fetch trending movies for a given page
  static Future<Map<String, dynamic>> getTrendingMovies(int page) async {
    final endpoint = _buildApiEndpoint(_trendingMoviesEndpoint, page);
    final url = Uri.parse(endpoint);

    try {
      final response = await http.get(url);

      print(response.statusCode);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch movies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching trending movies: $e');
    }
  }
}
