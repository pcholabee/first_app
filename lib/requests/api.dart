import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wallpaper.dart';
import '../models/api_response.dart';

class WallhavenApiService {
  static const String _baseUrl = 'https://wallhaven.cc/api/v1';
  static const Duration _timeout = Duration(seconds: 15);

  // Основной метод для поиска обоев
  static Future<WallhavenResponse> searchWallpapers({
    String query = '',
    String categories = '111', // 1=general, 1=anime, 1=people
    String purity = '100', // 1=sfw, 0=sketchy, 0=nsfw
    String sorting = 'date_added', // date_added, relevance, random, views, favorites
    String order = 'desc',
    String? colors,
    String? ratios,
    int page = 1,
    int perPage = 24,
  }) async {
    try {
      // Строим URL с параметрами
      final params = {
        'q': query,
        'categories': categories,
        'purity': purity,
        'sorting': sorting,
        'order': order,
        'page': page.toString(),
      };

      if (colors != null) params['colors'] = colors;
      if (ratios != null) params['ratios'] = ratios;

      final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: params);
      
      print('🌐 Wallhaven API запрос: $uri');
      print('📡 Параметры: $params');

      final response = await http.get(uri).timeout(_timeout);

      print('📥 Ответ API: статус ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final responseObj = WallhavenResponse.fromJson(data);
        print('✅ Успешно получено ${responseObj.data.length} обоев');
        return responseObj;
      } else if (response.statusCode == 429) {
        throw Exception('Превышен лимит запросов. Попробуйте позже.');
      } else {
        throw Exception('Ошибка API ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Ошибка запроса: $e');
      throw Exception('Ошибка сети: $e');
    }
  }

  // Популярные обои
  static Future<WallhavenResponse> getPopularWallpapers({int page = 1}) async {
    return searchWallpapers(
      sorting: 'views',
      order: 'desc',
      page: page,
    );
  }

  // Последние обои
  static Future<WallhavenResponse> getLatestWallpapers({int page = 1}) async {
    return searchWallpapers(
      sorting: 'date_added',
      order: 'desc',
      page: page,
    );
  }

  // Случайные обои
  static Future<WallhavenResponse> getRandomWallpapers({int page = 1}) async {
    return searchWallpapers(
      sorting: 'random',
      order: 'desc',
      page: page,
    );
  }

  // Поиск по тегам
  static Future<WallhavenResponse> searchByTag(String tag, {int page = 1}) async {
    return searchWallpapers(
      query: tag,
      sorting: 'relevance',
      page: page,
    );
  }

  // Получить информацию об обоях по ID
  static Future<Wallpaper> getWallpaperById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/w/$id'),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Wallpaper.fromJson(data['data']);
      } else {
        throw Exception('Ошибка получения обоев: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Поиск по категориям
  static Future<WallhavenResponse> getWallpapersByCategory(
    String category, {
    int page = 1,
  }) async {
    final categories = {
      'general': '100',
      'anime': '010',
      'people': '001',
    };

    return searchWallpapers(
      categories: categories[category] ?? '100',
      page: page,
    );
  }
}