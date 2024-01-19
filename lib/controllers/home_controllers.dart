import 'package:e_commerce_application/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  @override
  void onInit() {
    getUsername();
    super.onInit();
  }

  var searchController = TextEditingController();

  var currentNavIndex = 0.obs;

  var username = '';

  getUsername() async {
    var n = await firestore.collection(userCollection).where('id', isEqualTo: currentUser!.uid).get().then((value) {
      if(value.docs.isNotEmpty){
        return value.docs.single['name'];
      }
      else{
        return "Guest User";
      }
    });

    username = n;

  }

}