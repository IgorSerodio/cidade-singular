import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/creative_economy_type.dart';

class TypeFilter extends StatefulWidget {
  const TypeFilter({Key? key, required this.onSelect}) : super(key: key);

  final Function(String?) onSelect;

  @override
  _TypeFilterState createState() => _TypeFilterState();
}

class _TypeFilterState extends State<TypeFilter> {
  CreativeEconomyType? curatorFilter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: CreativeEconomyType.values.length+1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              if(index == 0){
                curatorFilter = null;
              } else {
                curatorFilter = CreativeEconomyType.values[index-1];
              }
            });
            widget.onSelect(curatorFilter?.toString().split(".").last);
          },
          child: Opacity(
            opacity: isSelected(index)? 1 : .6,
            child: Container(
              decoration: BoxDecoration(
                  color: index == 0
                      ?Constants.grey
                      :Constants.getColor(
                      CreativeEconomyType.values[index-1].toString().split(".").last),
                  borderRadius: BorderRadius.circular(50)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(
                left: index == 0 ? 32 : 0,
                right: 16,
                top: isSelected(index) ? 0 : 5,
                bottom: isSelected(index) ? 0 : 5,
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
                        Text(CreativeEconomyType.values[index-1].value),
                        SvgPicture.asset(
                            "assets/images/${CreativeEconomyType.values[index-1].toString().split(".").last}.svg",
                            width: 20)
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  bool isSelected(index){
    if (curatorFilter == null && index == 0) {
      return true;
    }
    if (index != 0 && curatorFilter == CreativeEconomyType.values[index - 1]) {
      return true;
    }
    return false;
  }
}
