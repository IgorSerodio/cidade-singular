import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuWidget extends StatelessWidget {
  VoidCallback onPressed;
  String title;
  IconData? icon;
  String? svgIconPath;
  bool selected = false;
  MenuWidget({
    Key? key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.svgIconPath,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svgIconPath == null
                ? Icon(
                    icon,
                    size: selected ? 26 : 22,
                    color: selected
                        ? Constants.primaryColor
                        : Constants.disableColor,
                  )
                : SvgPicture.asset(
                    svgIconPath ?? "",
                    color: selected
                        ? Constants.primaryColor
                        : Constants.disableColor,
                    width: selected ? 26 : 22,
                    height: selected ? 26 : 22,
                  ),
            Text(
              title,
              style: TextStyle(
                color:
                    selected ? Constants.primaryColor : Constants.disableColor,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
