import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/services/firestore_services.dart';
import 'package:e_commerce_application/views/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(), 
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          print(snapshot);
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          }
          else if(snapshot.data!.docs.isEmpty){
            return "No Messages ".text.color(darkFontGrey).makeCentered();
          }
          else{
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index){
                        return Card(
                          child: ListTile(
                            onTap: (){
                              Get.to(()=> const ChatScreen(),
                              arguments: [
                                data[index]['friend_name'],
                                data[index]['toId'],
                              ]
                            );
                            },
                            leading: const CircleAvatar(
                              backgroundColor: redColor,
                              child: Icon(
                                Icons.person,
                                color: whiteColor,
                              ),
                            ),
                            title: "${data[index]['friend_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                            subtitle: "${data[index]['last_msg']}".text.make(),
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            );
          }
        }
      ),
    );
  }
}