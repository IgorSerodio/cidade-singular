class Title {
  String id;
  String name;
  String description;
  String singularity;

  Title({
    required this.id,
    required this.name,
    this.description = "",
    required this.singularity,
  });

  Title.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        name = map["name"],
        description = map["description"] ?? "",
        singularity = map["singularity"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "singularity": singularity,
    };
  }
}