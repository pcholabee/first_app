class Wallpaper {
  final String id;
  final String url;
  final String thumbnail;
  final String fullImage;
  final int width;
  final int height;
  final String category;
  final int views;
  final int favorites;
  final String purity; // sfw, sketchy, nsfw
  final String uploader;
  final String uploadDate;
  final List<String> tags;
  final String source;

  Wallpaper({
    required this.id,
    required this.url,
    required this.thumbnail,
    required this.fullImage,
    required this.width,
    required this.height,
    required this.category,
    required this.views,
    required this.favorites,
    required this.purity,
    required this.uploader,
    required this.uploadDate,
    required this.tags,
    required this.source,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      thumbnail: json['thumbs']?['large'] ?? json['path'] ?? '',
      fullImage: json['path'] ?? json['url'] ?? '',
      width: json['resolution_x'] ?? 1920,
      height: json['resolution_y'] ?? 1080,
      category: json['category'] ?? 'general',
      views: json['views'] ?? 0,
      favorites: json['favorites'] ?? 0,
      purity: json['purity'] ?? 'sfw',
      uploader: json['uploader']?['username'] ?? 'Unknown',
      uploadDate: json['created_at'] ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tag) => tag['name'].toString())
              .toList() ??
          [],
      source: json['source'] ?? '',
    );
  }

  // Для отображения разрешения
  String get resolution => '$width×$height';
  
  // Проверка на безопасный контент
  bool get isSafe => purity == 'sfw';
  
  // Форматированная дата
  String get formattedDate {
    try {
      final date = DateTime.parse(uploadDate);
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return uploadDate;
    }
  }
}