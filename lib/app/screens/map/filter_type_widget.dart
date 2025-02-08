import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterTypeWidget extends StatefulWidget {
  const FilterTypeWidget({Key? key, required this.onChoose}) : super(key: key);
  final void Function(CuratorType?) onChoose;

  @override
  _FilterTypeWidgetState createState() => _FilterTypeWidgetState();
}

class _FilterTypeWidgetState extends State<FilterTypeWidget> {
  CuratorType selected = CuratorType.values.first;

  onSelect(CuratorType type) {
    setState(() {
      if (type.value == selected.value) {
        selected = CuratorType.values.first;
        widget.onChoose.call(null);
      } else {
        selected = type;
        widget.onChoose.call(selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CuratorType> types = [
      CuratorType.ARTS,
      CuratorType.CRAFTS,
      CuratorType.DESIGN,
      CuratorType.FILM,
      CuratorType.GASTRONOMY,
      CuratorType.LITERATURE,
      CuratorType.MUSIC
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: types
          .map(
            (type) => Expanded(
          child: buildTypeWidget(type, isSelected: type.value == selected.value),
        ),
      )
          .toList(),
    );
  }

  GestureDetector buildTypeWidget(CuratorType type, {bool isSelected = false}) {
    const double iniWidth = 250;
    const double sizeUp = 1.25;
    const double offsetX = (iniWidth / 2.8) * sizeUp;

    return GestureDetector(
      onTap: () {
        onSelect(type);
      },
      child: Container(
        width: isSelected ? iniWidth * sizeUp : iniWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "images/_${type.toString().split('.').last}.png",
              fit: BoxFit.contain,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    type.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: offsetX)
              ],
            ),
          ],
        ),
      ),
    );
  }
}