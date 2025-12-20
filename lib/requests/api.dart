import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nasa.dart';

class ApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1/images/search';

  static Future<NasaResponse> getPhotos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return NasaResponse.fromJson(data);
    } else {
      throw Exception('Ошибка загрузки: ${response.statusCode}');
    }
  }
}