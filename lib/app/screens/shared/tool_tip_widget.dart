import 'package:flutter/material.dart';

class ToolTipWidget extends StatelessWidget {
  final String message;

  const ToolTipWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text(message),
        ),
      ],
      child: Icon(Icons.help_outline),
    );
  }
}