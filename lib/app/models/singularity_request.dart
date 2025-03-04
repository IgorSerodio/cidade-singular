import 'criative_economy_type.dart';

class SingularityRequest {
  String visitingHours;
  String title;
  String description;
  String address;
  List<String> photos;
  String creator;
  CriativeEconomyType type;
  List<String> tags;

  SingularityRequest({
    required this.visitingHours,
    required this.title,
    required this.description,
    required this.address,
    required this.creator,
    required this.type,
    this.photos = const [],
    this.tags = const [],
  });

  SingularityRequest.fromMap(Map<String, dynamic> map)
      : visitingHours = map["visitingHours"],
        title = map["title"],
        description = map["description"],
        address = map["address"],
        photos = List<String>.from(map["photos"] ?? []),
        creator = map["creator"],
        type = CriativeEconomyType.from[map["type"]],
        tags = List<String>.from(map["tags"] ?? []);

  Map<String, dynamic> toMap() {
    return {
      "visitingHours": visitingHours,
      "title": title,
      "description": description,
      "address": address,
      "photos": photos,
      "creator": creator,
      "type": type.name,
      "tags": tags,
    };
  }
}
