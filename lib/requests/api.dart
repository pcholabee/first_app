import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nasa.dart';

class ApiService {
  static const String _apiKey = 'eQnprvXukgfNomTanZiHT1DqLApcABzFjI350dyZ';
  static const String _baseUrl = 'https://api.nasa.gov/mars-photos/api/v1/rovers/';

  static Future<NasaResponse> getPhotos(String rover, int sol) async {
    final url = '${_baseUrl}$rover/photos?sol=$sol&api_key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return NasaResponse.fromJson(data);
    } else {
      throw Exception('Failed to load photos. Status code: ${response.statusCode}');
    }
  }
}