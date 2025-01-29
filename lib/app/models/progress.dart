class Progress {
  String missionId;
  int value;
  int target;
  String missionDescription = "";
  String missionReward = "";

  Progress({
    required this.missionId,
    required this.value,
    required this.target,
    this.missionDescription = "",
    this.missionReward = "",
  });

  Progress.fromMap(Map map)
      : missionId = map["missionId"],
        value = map["value"],
        target = map["target"];
}