class Title {
  String id;
  String name;
  String description;
  String creator;

  Title({
    required this.id,
    required this.name,
    this.description = "",
    required this.creator,
  });

  Title.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        name = map["name"],
        description = map["description"] ?? "",
        creator = map["creator"];

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "name": name,
      "description": description,
      "creator": creator,
    };
  }
}