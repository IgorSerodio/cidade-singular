class Ticket {
  String id;
  String name;
  String description;
  String creator;

  Ticket({
    required this.id,
    required this.name,
    this.description = "",
    required this.creator,
  });

  Ticket.fromMap(Map<String, dynamic> map)
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