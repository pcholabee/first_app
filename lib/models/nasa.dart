import 'photo.dart';

class NasaResponse {
  final List<Photo> photos;

  NasaResponse({required this.photos});

  factory NasaResponse.fromJson(List<dynamic> jsonList) {
    List<Photo> photos = jsonList.map((json) => Photo.fromJson(json)).toList();
    return NasaResponse(photos: photos);
  }
}