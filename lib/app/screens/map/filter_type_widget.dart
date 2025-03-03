import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/criative_economy_type.dart';

class FilterTypeWidget extends StatefulWidget {
  const FilterTypeWidget({Key? key, required this.onChoose}) : super(key: key);
  final void Function(CriativeEconomyType?) onChoose;

  @override
  _FilterTypeWidgetState createState() => _FilterTypeWidgetState();
}

class _FilterTypeWidgetState extends State<FilterTypeWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  onSelect(CriativeEconomyType type) {
    setState(() {
      if (type.value == selected.value) {
        selected = CriativeEconomyType.values.first;
        widget.onChoose.call(null);
      } else {
        selected = type;
        widget.onChoose.call(selected);
      }
    });

    _controller.forward().then((value) => _controller.reverse());
  }

  CriativeEconomyType selected = CriativeEconomyType.values.first;

  @override
  Widget build(BuildContext context) {
    final curve =
    CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);
    Animation<int> animation = IntTween(begin: 0, end: 80).animate(curve);

    List<CriativeEconomyType> types = [
      CriativeEconomyType.ARTS,
      CriativeEconomyType.CRAFTS,
      CriativeEconomyType.DESIGN,
      CriativeEconomyType.FILM,
      CriativeEconomyType.GASTRONOMY,
      CriativeEconomyType.LITERATURE,
      CriativeEconomyType.MUSIC
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: types
          .map(
              (type) =>
              Expanded(child: type.value == selected.value
                  ? AnimatedBuilder(
                animation: animation,
                child: buildTypeWidget(type, isSelected: true),
                builder: (context, child) =>
                    Transform.translate(
                      offset: Offset(animation.value.toDouble(), 0),
                      child: child,
                    ),
              )
                  : buildTypeWidget(type, isSelected: false),
              )
      )
          .toList(),
    );
  }

  GestureDetector buildTypeWidget(CriativeEconomyType type, {bool isSelected = false}) {
    const double iniWidth = 250;
    const double sizeUp = 1.25;
    const double offsetX = (iniWidth / 2.8)*sizeUp;

    return GestureDetector(
      onTap: () {
        onSelect(type);
      },
      child: Container(
        transform: Transform.translate(
          offset:  Offset(isSelected ? -120 : -150, 0),
        ).transform,
        width: isSelected ? iniWidth * sizeUp : iniWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/_${type.toString().split('.').last}.svg",
              fit: BoxFit.contain,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
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
                SizedBox(width: offsetX,)
              ]
            ),
          ]
        ),
      ),
    );
  }
}
