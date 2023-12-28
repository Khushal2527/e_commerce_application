import 'package:e_commerce_application/consts/consts.dart';
import 'package:flutter/material.dart';

Widget bgWidget( {Widget? child} ){
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      image: DecorationImage(
        image: AssetImage(imgBackground),
        fit: BoxFit.fill
      )
    ),
    child: child,
  );
}