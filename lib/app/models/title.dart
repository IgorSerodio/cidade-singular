class Title {
  String id;
  String name;
  String description;
  String singularity;
  String creator;

  Title({
    required this.id,
    required this.name,
    this.description = "",
    required this.singularity,
    required this.creator,
  });

  Title.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        name = map["name"],
        description = map["description"] ?? "",
        singularity = map["singularity"],
        creator = map["creator"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "singularity": singularity,
      "creator": creator,
    };
  }
}