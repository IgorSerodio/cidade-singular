class Progress {
  String missionId;
  int value;
  int target;
  List<String> sources;

  Progress({
    required this.missionId,
    required this.value,
    required this.target,
    required this.sources,
  });

  Progress.fromMap(Map map)
      : missionId = map["missionId"],
        value = map["value"],
        target = map["target"],
        sources = List<String>.from(map["sources"]);
}