import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/views/home_screen/home.dart';
import 'package:e_commerce_application/widgets_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../auth_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  changeScreen(){
    Future.delayed(const Duration(seconds: 3),(){
      auth.authStateChanges().listen(( User? users) {
        if(users == null && mounted){
          Get.to(()=> const LoginScreen());
        }
        else{
          Get.to(()=> const Home());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container()
          ),
          20.heightBox,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: applogoWidget()
          ),
          10.heightBox,
          appname.text.fontFamily(bold).size(22).white.make(),
          5.heightBox,
        ],
      ),
    );
  }
}