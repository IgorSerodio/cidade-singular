import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'dart:html';
import 'package:flutter/foundation.dart' show kIsWeb;

class URLImage extends StatelessWidget {
  String url;

  URLImage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(!kIsWeb) return Image.network(url, fit: BoxFit.cover);
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      url,
          (int _) => ImageElement()..src = url,
    );
    return HtmlElementView(
      viewType: url,
    );
  }
}