import 'package:flutter/material.dart';

class MenuPageModel {
  String name;
  IconData? icon;
  String? svgIconPath;
  Widget page;

  MenuPageModel({
    required this.name,
    required this.page,
    this.icon,
    this.svgIconPath,
  });
}
