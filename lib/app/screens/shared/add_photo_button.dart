import 'package:flutter/material.dart';

class AddPhotoButton extends StatelessWidget{
  final VoidCallback onTap;
  final double width;
  final double height;
  const AddPhotoButton({
    Key? key,
    required this.onTap,
    this.width = 100,
    this.height = 100
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
        child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600]),
      ),
    );
  }

}