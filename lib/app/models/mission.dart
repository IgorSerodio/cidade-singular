class Mission {
  String id;
  String city;
  String description;
  List<String> tags;
  int target;
  String reward;
  RewardType rewardType;
  String? sponsor;

  Mission({
    required this.id,
    required this.city,
    required this.description,
    required this.tags,
    required this.target,
    required this.reward,
    required this.rewardType,
    this.sponsor,
  });

  Mission.fromMap(Map<String, dynamic> map)
      : id = map["_id"],
        city = map["city"],
        description = map["description"] ?? "",
        tags = List<String>.from(map["tags"] ?? []),
        target = map["target"],
        reward = map["reward"],
        rewardType = rewardTypeFromString[map["rewardType"]]!,
        sponsor = map["sponsor"];

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'description': description,
      'tags': tags,
      'target': target,
      'reward': reward,
      'rewardType': rewardType.name,
      'sponsor': sponsor,
    };
  }
}

enum RewardType {
  ACCESSORY,
  TICKET,
  TITLE,
}

final Map<String, RewardType> rewardTypeFromString =  {
  for(var type in RewardType.values)
    type.name: type,
};


extension RewardTypeExtension on RewardType {

  String get value {
    switch (this) {
      case RewardType.ACCESSORY:
        return "Acessório";
      case RewardType.TICKET:
        return "Ingresso";
      case RewardType.TITLE:
        return "Título";
      default:
        return "Não definido";
    }
  }
}
