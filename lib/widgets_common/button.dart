import 'package:e_commerce_application/consts/consts.dart';
import 'package:flutter/material.dart';

Widget ourButton({onPress,color,textcolor, String? title}){
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.all(12),
    ),
    onPressed: onPress,
    child: title!.text.color(textcolor).fontFamily(semibold).make(),
  );
}