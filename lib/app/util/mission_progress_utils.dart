enum TaskType { VISIT, REVIEW, CUSTOM}

class MissionProgressUtils {

  static String formatSource(String source) {
    DateTime today = DateTime.now();
    return '$source - ${today.year.toString()}/${today.month.toString().padLeft(2,'0')}/${today.day.toString().padLeft(2,'0')}';
  }

}
