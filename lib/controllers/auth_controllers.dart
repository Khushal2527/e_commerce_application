// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  var isLoading = false.obs;

  var emailController = TextEditingController(); 
  var passwordController = TextEditingController(); 

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    print(userCredential);

    try{
      userCredential = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    }
    on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
      return null;
    }

    print(userCredential);
    return userCredential;
  }

    Future<UserCredential?> signUpMethod({email,password,context}) async {
    UserCredential? userCredential;

    try{
      userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential);
    }
    on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }

    return userCredential;
  }


  storeUserData({name,password,email,}) async {

    DocumentReference store = await firestore.collection(userCollection).doc(currentUser!.uid);
    store.set({
      'name':name,
      'password':password,
      'email':email,
      'imageUrl':'',
      'id':currentUser!.uid,
      'cart_count': "00",
      'order_count': "00",
      'wishlist_count': "00",
    });
    print("UserAdded");
  }

  signoutMethod(context) async{

    try{
      await auth.signOut();
    }
    catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }

}