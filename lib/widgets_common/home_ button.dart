import 'package:e_commerce_application/consts/consts.dart';
import 'package:flutter/material.dart';

Widget homeButtons({width,height,icon,String? title,onpress}){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(icon,width: 26,),
      10.heightBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  ).box.white.rounded.size(width, height).make();
}