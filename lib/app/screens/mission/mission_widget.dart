import 'package:cidade_singular/app/models/user.dart';
import 'package:flutter/cupertino.dart';

class MissionProgressWidget extends StatelessWidget {
  const MissionProgressWidget({
    Key? key,
    required this.progress,
    this.margin = const EdgeInsets.all(16),
    this.completed = false,
  }) : super(key: key);

  final Progress progress;
  final EdgeInsets margin;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}