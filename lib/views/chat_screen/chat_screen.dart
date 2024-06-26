import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/chats_controller.dart';
import 'package:e_commerce_application/services/firestore_services.dart';
import 'package:e_commerce_application/views/chat_screen/components/sender_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(ChatsController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "${controller.sellerName}".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx( ()=> controller.isLoading.value 
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor) ,
                ),
              ) 
              : Expanded(
                child: StreamBuilder(
                  stream: FirestoreServices.getChatMessages(controller.chatDocId.toString()),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    print(snapshot.data);
                    print(snapshot.connectionState);
                    if(!snapshot.hasData){
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        ),
                      );
                    }
                    else if(snapshot.data!.docs.isEmpty){
                      return Center(
                        child: "Send a message".text.color(darkFontGrey).make(),
                      );
                    }
                    else{
                      return ListView(
                        children: snapshot.data!.docs.mapIndexed((currentValue, index){
                          var data = snapshot.data!.docs[index];
                          return Align(
                            alignment: data['uid'] == currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,
                            child: senderBubble(data)
                          );
                        }).toList(),
                      );
                    }
                  }
                )
              ),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.messageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textfieldGrey
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textfieldGrey
                        )
                      ),
                      hintText: "Type a Message..",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    controller.sendMessage(controller.messageController.text,);
                    controller.messageController.clear();
                  },
                  icon: const Icon(Icons.send)
                )
              ],
            ).box.height(80).padding(const EdgeInsets.all(12)).margin(const EdgeInsets.only(bottom: 8)).make()
          ],
        ),
      ),
    );
  }
}