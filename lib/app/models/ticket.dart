class Ticket {
  String id;
  String name;
  String description;
  String singularity;
  String creator;

  Ticket({
    required this.id,
    required this.name,
    this.description = "",
    required this.singularity,
    required this.creator,
  });

  Ticket.getDefault():
      id = "",
      name = "",
      description = "",
      singularity = "",
      creator = "";

  Ticket.fromMap(Map<String, dynamic> map)
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