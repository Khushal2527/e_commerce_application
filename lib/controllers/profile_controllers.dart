import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController{

  var profileImgPath = ''.obs;

  var profileImgLink = '';

  var isLoading = false.obs;

  var nameController = TextEditingController();
  var newPassController = TextEditingController();
  var oldPassController = TextEditingController();

  changeImage(context) async{
    try{
      final img = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70);
      if(img == null)return;
      profileImgPath.value = img.path;
    }
    on PlatformException catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImg() async{
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImgLink = await ref.getDownloadURL();
  }

  updateProfile({name,password,imgUrl}) async {
    var store = firestore.collection(userCollection).doc(currentUser!.uid);
    store.set({
      'name':name,
      'password':password,
      'imageUrl': imgUrl
    },SetOptions(merge: true));
    // isLoading = false;
    isLoading(false);
  }

  changeAuthPassword({email,password,newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value){
      currentUser!.updatePassword(newpassword).catchError((error){
        print(error.toString());
      });
    });
  }


}