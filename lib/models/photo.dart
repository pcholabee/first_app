class Photo {
  final String id;
  final String url;

  Photo({required this.id, required this.url});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
  };
}