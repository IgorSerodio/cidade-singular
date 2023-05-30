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

    _controller.forward().then((value) => _controller.reverse());
  }

  CuratorType selected = CuratorType.values.first;
  @override
  Widget build(BuildContext context) {
    final curve =
        CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);
    Animation<int> animation = IntTween(begin: 0, end: 120).animate(curve);

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
            (type) => type.value == selected.value
                ? AnimatedBuilder(
                    animation: animation,
                    child: buildTypeWidget(type, isSelected: true),
                    builder: (context, child) => Transform.translate(
                      offset: Offset(animation.value.toDouble(), 0),
                      child: child,
                    ),
                  )
                : buildTypeWidget(type, isSelected: false),
          )
          .toList(),
    );
  }

  GestureDetector buildTypeWidget(CuratorType type, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        onSelect(type);
      },
      child: Opacity(
        opacity: isSelected ? 1 : 1,
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(
              image: AssetImage("assets/images/_${type.toString().split(".").last}.png"),
              fit: BoxFit.fitWidth,),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 12 : 10,
            vertical: isSelected ? 30 : 25,
          ),
          transform: Transform.translate(
            offset: Offset(isSelected ? -110 : -110, 0),
          ).transform,
          width: isSelected ? 180 : 160,
          /*child: Center(
              child: Text(type.value)),*/
        ),
      ),
    );
  }
}
