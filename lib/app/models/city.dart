import 'package:google_maps_flutter/google_maps_flutter.dart';

class City {
  String id;
  String title;
  String subtitle;
  String description;
  List<String> pictures;
  String blazon;
  LatLng latLng;

  City({
    required this.id,
    required this.title,
    required this.pictures,
    required this.subtitle,
    required this.description,
    required this.blazon,
    required this.latLng,
  });

  City.fromMap(map)
      : id = map["_id"],
        title = map["title"],
        pictures = List<String>.from(map["pictures"]),
        subtitle = map["subtitle"],
        description = map["description"],
        blazon = map["blazon"],
        latLng = LatLng(map["lat"], map["lng"]);
}
