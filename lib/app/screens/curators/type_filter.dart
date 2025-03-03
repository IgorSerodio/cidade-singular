import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/criative_economy_type.dart';

class TypeFilter extends StatefulWidget {
  const TypeFilter({Key? key, required this.onSelect}) : super(key: key);

  final Function(String?) onSelect;

  @override
  _TypeFilterState createState() => _TypeFilterState();
}

class _TypeFilterState extends State<TypeFilter> {
  CriativeEconomyType curatorFilter = CriativeEconomyType.values[0];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: CriativeEconomyType.values.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              curatorFilter = CriativeEconomyType.values[index];
            });
            widget.onSelect(curatorFilter != CriativeEconomyType.values[0]
                ? curatorFilter.toString().split(".").last
                : null);
          },
          child: Opacity(
            opacity: curatorFilter == CriativeEconomyType.values[index] ? 1 : .6,
            child: Container(
              decoration: BoxDecoration(
                  color: Constants.getColor(
                      CriativeEconomyType.values[index].toString().split(".").last),
                  borderRadius: BorderRadius.circular(50)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(
                left: index == 0 ? 32 : 0,
                right: 16,
                top: curatorFilter == CriativeEconomyType.values[index] ? 0 : 5,
                bottom: curatorFilter == CriativeEconomyType.values[index] ? 0 : 5,
              ),
              child: index == 0
                  ? Center(
                      child: Text(
                      "Todos",
                      style: TextStyle(color: Colors.black),
                    ))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(CriativeEconomyType.values[index].value),
                        SvgPicture.asset(
                            "assets/images/${CriativeEconomyType.values[index].toString().split(".").last}.svg",
                            width: 20)
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
