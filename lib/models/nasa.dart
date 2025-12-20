import 'photo.dart';

class NasaResponse {
  final List<Photo> photos;

  NasaResponse({required this.photos});

  factory NasaResponse.fromJson(Map<String, dynamic> json) {
    var photosList = json['photos'] as List;
    List<Photo> photos = photosList.map((i) => Photo.fromJson(i)).toList();

    return NasaResponse(photos: photos);
  }
}