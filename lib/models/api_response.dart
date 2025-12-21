import 'wallpaper.dart';

class WallhavenResponse {
  final List<Wallpaper> data;
  final Meta meta;

  WallhavenResponse({
    required this.data,
    required this.meta,
  });

  factory WallhavenResponse.fromJson(Map<String, dynamic> json) {
    return WallhavenResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => Wallpaper.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? query;
  final String? seed;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.query,
    this.seed,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 24,
      total: json['total'] ?? 0,
      query: json['query'],
      seed: json['seed'],
    );
  }
}