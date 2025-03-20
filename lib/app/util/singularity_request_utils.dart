import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class SingularityResquestUtils {

  static Future<List<String>> convertToEncodedList(List<XFile> imageList) async {
    return await Future.wait(imageList.map((image) async {
      List<int> imageBytes = await image.readAsBytes();
      return base64Encode(imageBytes);
    }).toList());
  }
}