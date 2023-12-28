// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/profile_controllers.dart';
import 'package:e_commerce_application/widgets_common/bg.dart';
import 'package:e_commerce_application/widgets_common/button.dart';
import 'package:e_commerce_application/widgets_common/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<ProfileController>();

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: BackButton(
            color: whiteColor,
          ),
          elevation: 0.0,
        ),
        body: Obx(()=>
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty 
                ? Image.asset(imgProfile,width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make() 
                : data['imageUrl'] != '' && controller.profileImgPath.isEmpty 
                  ? Image.network(data['imageUrl'],width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make()
                  : Image.file(File(controller.profileImgPath.value),width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ourButton(color: redColor,onPress: (){
                controller.changeImage(context);
              },textcolor: whiteColor,title: "Change"),
              const Divider(),
              20.heightBox,
              customTextField(
                controller: controller.nameController,
                hint: nameHint,
                title: name,
                isPass: false,
              ),
              10.heightBox,
              customTextField(
                controller: controller.oldPassController,
                hint: passwordHint,
                title: oldpass,
                isPass: true,
              ),
              10.heightBox,
              customTextField(
                controller: controller.newPassController,
                hint: passwordHint,
                title: newpass,
                isPass: true,
              ),
              20.heightBox,
              controller.isLoading.value ?
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ) : SizedBox(
                width: context.screenWidth-60,
                child: ourButton(color: redColor,onPress: () async {
                  controller.isLoading(true);
                  if(controller.profileImgPath.isNotEmpty){
                    await controller.uploadProfileImg();
                  }
                  else{
                    controller.profileImgLink = data["imageUrl"];
                  }

                  if(controller.oldPassController.text == data["password"]){
                    await controller.changeAuthPassword(
                      email: data["email"],
                      password: controller.oldPassController.text,
                      newpassword: controller.newPassController.text,
                    );
                    await controller.updateProfile(
                      imgUrl: controller.profileImgLink,
                      name: controller.nameController.text,
                      password: controller.newPassController.text
                    );
                    VxToast.show(context, msg: "Updated");
                  }
                  else{
                    VxToast.show(context, msg: "Old Password is Wrong!");
                    controller.isLoading(false);
                  }
                  
                },textcolor: whiteColor,title: "Save"),
              ),
            ],
          ).box.white.rounded.shadowSm.padding(const EdgeInsets.all(16)).margin(const EdgeInsets.only(top: 50,left: 12,right: 12)).make(),
        ),
      )
    );
  }
}