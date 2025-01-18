class Mission {
  String id;
  String city;
  String description;
  List<String> tags;
  int target;
  String? reward;

  Mission({
    required this.id,
    required this.city,
    required this.description,
    required this.tags,
    required this.target,
    this.reward,
  });

  Mission.fromMap(Map<String, dynamic> map)
      : id = map["_id"] ?? "",
        city = map["city"] ?? "",
        description = map["description"] ?? "",
        tags = List<String>.from(map["tags"] ?? []),
        target = map["target"] ?? 0,
        reward = map["reward"];

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'city': city,
      'description': description,
      'tags': tags,
      'target': target,
      'reward': reward,
    };
  }
}
