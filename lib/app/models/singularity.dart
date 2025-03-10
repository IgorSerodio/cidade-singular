import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'criative_economy_type.dart';

class Singularity {
  String id;
  String visitingHours;
  String title;
  String description;
  String address;
  CriativeEconomyType type;
  List<String> photos;
  LatLng latLng;
  List<String> tags;
  String? creator;
  String city;

  Singularity({
    required this.id,
    required this.address,
    required this.description,
    required this.title,
    required this.type,
    required this.visitingHours,
    required this.photos,
    required this.city,
    this.creator,
    required this.latLng,
    required this.tags,
  });

  Singularity.fromMap(map)
      : id = map["_id"],
        visitingHours = map["visitingHours"],
        title = map["title"],
        description = map["description"],
        address = map["address"],
        city = map["city"],
        type = CriativeEconomyType.from[map["type"]],
        photos = List<String>.from(map["photos"]),
        latLng = LatLng(map["lat"], map["lng"]),
        creator = map["creator"],
        tags = List<String>.from(map["tags"]);
}