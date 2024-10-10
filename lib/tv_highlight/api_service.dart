// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'match_model.dart';

class ApiService {
  final String apiKey =
      'f6a7515132mshe22385aed4e12c3p171e02jsn6fa43c6352f9'; // Replace with your actual RapidAPI key
  final String apiHost = 'free-football-soccer-videos.p.rapidapi.com';

  Future<List<Match>> fetchMatches() async {
    final url = Uri.parse('https://$apiHost/');

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': apiHost,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Match> matches =
          jsonData.map((json) => Match.fromJson(json)).toList();
      return matches;
    } else {
      throw Exception('Failed to load matches');
    }
  }
}
