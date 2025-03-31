import 'creative_economy_type.dart';

class SingularityRequest {
  String id;
  String visitingHours;
  String title;
  String description;
  String address;
  List<String> photos;
  String creator;
  CreativeEconomyType type;
  List<String> tags;
  String city;
  int maturity;
  String? email;
  String? phone;

  SingularityRequest({
    required this.id,
    required this.visitingHours,
    required this.title,
    required this.description,
    required this.address,
    required this.city,
    required this.creator,
    required this.type,
    this.photos = const [],
    this.tags = const [],
    this.maturity = 0,
    this.phone,
    this.email,
  });

  SingularityRequest.fromMap(Map<String, dynamic> map)
      : id = map["_id"] ?? "",
        visitingHours = map["visitingHours"] ?? "",
        title = map["title"] ?? "",
        description = map["description"] ?? "",
        address = map["address"] ?? "",
        photos = List<String>.from(map["photos"] ?? []),
        city = map["city"] ?? "",
        creator = map["creator"],
        type = creativeTypeFromString[map["type"]] ?? CreativeEconomyType.ARTS,
        tags = List<String>.from(map["tags"] ?? []),
        maturity = map["maturity"] ?? 0,
        phone = map["phone"],
        email = map["email"];

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
      "city": city,
      "maturity": maturity,
      if(email!=null)"email": email,
      if(phone!=null)"phone": phone,
    };
  }
}
