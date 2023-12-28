import 'package:e_commerce_application/consts/consts.dart';
import 'package:flutter/material.dart';

Widget orderStatus({icon,color,title,showDone}){
  return ListTile(
    leading: Icon(
      icon,
      color: color,
    ).box.border(color: color).roundedSM.padding(const EdgeInsets.all(4)).make(),
    trailing: SizedBox(
      width: 120,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          "$title".text.color(darkFontGrey).make(),
          showDone ? const Icon(
            Icons.done,
            color: redColor,
          ) : Container()
        ],
      ),
    ),
  );
}