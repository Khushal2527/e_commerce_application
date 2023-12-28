import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/home_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController{

  @override
  void onInit() {
    getChatId();
    super.onInit();
  }


  var chats = firestore.collection(chatsCollection);

  var sellerName = Get.arguments[0];

  var sellerId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var messageController = TextEditingController();

  dynamic chatDocId;

  var isLoading = false.obs;

  getChatId () async{
    isLoading(true);
    await chats.where('users',isEqualTo: {
      sellerId:null,
      currentId:null,
    }).limit(1).get().then((QuerySnapshot snapshot) {
      if(snapshot.docs.isNotEmpty){
        chatDocId = snapshot.docs.single.id;
      }
      else{
        chats.add({
          'created_on': null,
          'last_msg':'',
          'users':{ sellerId:null, currentId: null},
          'toId':'',
          'fromId':'',
          'friend_name':sellerName,
          'sender_name':senderName
        }).then((value) {
          chatDocId = value.id;
        });
      }
    });
    isLoading(false);
  }

  sendMessage (String msg) async {
    if(msg.trim().isNotEmpty){
      chats.doc(chatDocId).update({
        'created_on':FieldValue.serverTimestamp(),
        'last_msg':msg,
        'toId':sellerId,
        'fromId': currentId,
      });

      chats.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on':FieldValue.serverTimestamp(),
        'last_msg':msg,
        'uid': currentId,
      });
    }
  }

}