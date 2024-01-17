// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/consts/lists.dart';
import 'package:e_commerce_application/controllers/auth_controllers.dart';
import 'package:e_commerce_application/controllers/profile_controllers.dart';
import 'package:e_commerce_application/services/firestore_services.dart';
import 'package:e_commerce_application/views/chat_screen/messaging_screen.dart';
import 'package:e_commerce_application/views/orders_screen/orders_screen.dart';
import 'package:e_commerce_application/views/profile_screen/details_card.dart';
import 'package:e_commerce_application/views/profile_screen/edit_profile.dart';
import 'package:e_commerce_application/views/splash_screen/splash_screen.dart';
import 'package:e_commerce_application/views/wishlist_screen/wishlist_screen.dart';
import 'package:e_commerce_application/widgets_common/bg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(ProfileController());
    FirestoreServices.getCounts();

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            }
            else{
              var data = snapshot.data!.docs[0];
              return SafeArea(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.edit,color: whiteColor)
                      ),
                    ).onTap(() {
                      controller.nameController.text = data["name"];
                      Get.to(()=> EditProfileScreen(data: data));
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data["imageUrl"] == '' ?
                            Image.asset(imgProfile,width: 80,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make():
                            Image.network(data["imageUrl"],width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make(),
                          10.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data["name"]}".text.fontFamily(semibold).color(whiteColor).make(),
                                5.heightBox,
                                "${data["email"]}".text.white.make()
                              ],
                            )
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: whiteColor
                              )
                            ),
                            onPressed: () async {
                              await Get.put(AuthController().signoutMethod(context));
                              Get.offAll(()=> const SplashScreen());
                            },
                            child: logout.text.fontFamily(semibold).color(whiteColor).make()
                          ),
                        ],
                      ),
                    ),
                    10.heightBox,
                    FutureBuilder(
                      future: FirestoreServices.getCounts(), 
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(!snapshot.hasData){
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(redColor),
                            ),
                          );
                        }
                        else {
                          print(snapshot.data);
                          var countData = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              detailsCard(count: countData[0].toString(),title: "In Cart",width: context.screenWidth/3.5),
                              detailsCard(count: countData[1].toString(),title: "Your Wishlist",width: context.screenWidth/3.5),
                              detailsCard(count: countData[2].toString(),title: "Your Orders",width: context.screenWidth/3.5),
                            ],
                          );   
                        }
                      }
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: lightGrey,
                        );
                      },
                      itemCount: profileButtonsList.length,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          onTap: (){
                            switch(index){
                              case 0: Get.to(()=> const WishlistScreen());break;
                              case 1: Get.to(()=> const OrderScreen());break;
                              case 2: Get.to(()=> const MessagesScreen());break;
                            }
                          },
                          leading: Image.asset(profileButtonsIcons[index],width: 22,),
                          title: profileButtonsList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                        );
                      }
                    ).box.white.rounded.margin(const EdgeInsets.all(12)).padding(const EdgeInsets.symmetric(horizontal: 16)).shadowSm.make().box.color(redColor).make(),
                  ],
                ),
              );
            }
          }
        )
      )
    );
  }
}