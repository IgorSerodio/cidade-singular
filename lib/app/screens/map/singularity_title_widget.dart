import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingularityTitleWidget extends StatelessWidget{

  const SingularityTitleWidget(this.name, this.globalKey, {Key? key}) : super(key: key);
  final GlobalKey globalKey;
  final String name;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: globalKey,
        child:Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black87.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
    );
  }
}