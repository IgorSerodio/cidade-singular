import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'creative_economy_type.dart';

class Singularity {
  String id;
  String visitingHours;
  String title;
  String description;
  String address;
  CreativeEconomyType type;
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

  Singularity.getDefault():
      id = "",
      visitingHours = "",
      title = "",
      description = "",
      address = "",
      city = "",
      type = CreativeEconomyType.ARTS,
      photos = [],
      latLng = LatLng(0, 0),
      tags = [];


  Singularity.fromMap(map)
      : id = map["_id"],
        visitingHours = map["visitingHours"],
        title = map["title"],
        description = map["description"],
        address = map["address"],
        city = map["city"],
        type = creativeTypeFromString[map["type"]]!,
        photos = List<String>.from(map["photos"]),
        latLng = LatLng(map["lat"], map["lng"]),
        creator = map["creator"],
        tags = List<String>.from(map["tags"]);



  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "visitingHours": visitingHours,
      "address": address,
      "city": city,
      "type": type.name,
      "description": description,
      "creator": creator,
      "lat": latLng.latitude,
      "lng": latLng.longitude,
      "photos": photos,
      "tags": tags,
    };
  }
}