class Progress {
  String missionId;
  int value;
  int target;

  Progress({
    required this.missionId,
    required this.value,
    required this.target,
  });

  Progress.fromMap(Map map)
      : missionId = map["missionId"],
        value = map["value"],
        target = map["target"];
}