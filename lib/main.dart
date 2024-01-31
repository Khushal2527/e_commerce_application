// Customer Application   fir

import "package:e_commerce_application/firebase_options.dart";
import "package:e_commerce_application/views/splash_screen/splash_screen.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "consts/consts.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build (BuildContext context){
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme( 
          iconTheme: IconThemeData(
            color: darkFontGrey
          ), 
          backgroundColor: Colors.transparent
        ),
        fontFamily: regular
      ),
      home: const SplashScreen(),
    );
  }
}

