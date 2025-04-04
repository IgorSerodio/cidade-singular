enum TaskType { VISIT, REVIEW, CUSTOM}

extension TaskTypeExtension on TaskType {

  String get value {
    switch (this) {
      case TaskType.VISIT:
        return "Visitar";
      case TaskType.REVIEW:
        return "Avaliar";
      case TaskType.CUSTOM:
        return "Personalizado";
      default:
        return "Não definido";
    }
  }
}

class MissionProgressUtils {

  static final Map<String, TaskType> taskTypeFromString = {
    for (var type in TaskType.values) type.name: type
  };

  static String formatSource(String source) {
    DateTime today = DateTime.now();
    return '$source - ${today.year.toString()}/${today.month.toString().padLeft(2,'0')}/${today.day.toString().padLeft(2,'0')}';
  }

}
