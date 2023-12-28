// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/auth_controllers.dart';
import 'package:e_commerce_application/views/home_screen/home.dart';
import 'package:e_commerce_application/widgets_common/applogo_widget.dart';
import 'package:e_commerce_application/widgets_common/bg.dart';
import 'package:e_commerce_application/widgets_common/button.dart';
import 'package:e_commerce_application/widgets_common/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class  SignUpScreen extends StatefulWidget {
  const  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool? isChecked = false;
  var controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var passwordRetypeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight*0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Join the $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx( () => 
                Column(
                  children: [
                    customTextField( hint:nameHint, title: name,controller: nameController ,isPass: false ),
                    customTextField( hint:emailHint, title: email ,controller: emailController,isPass: false),
                    customTextField( hint: passwordHint,title: password ,controller: passwordController,isPass: true),
                    customTextField( hint: passwordHint,title: retypePassword ,controller: passwordRetypeController,isPass: true),
                    5.heightBox,
                    Row(
                      children: [
                        Checkbox(
                          checkColor: whiteColor,
                          activeColor: redColor,
                          value: isChecked,
                          onChanged: (newValue){
                            setState(() {
                              isChecked = newValue;
                            });
                          }
                        ),
                        10.widthBox,
                        Expanded(
                          child: RichText(text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "I agree to the ",
                                style: TextStyle(
                                  color: fontGrey,
                                  fontFamily: regular
                                )
                              ),
                              TextSpan(
                                text: termsAndCondition,
                                style: TextStyle(
                                  color: redColor,
                                  fontFamily: regular
                                )
                              ),
                              TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  color: fontGrey,
                                  fontFamily:regular,
                                )
                              ),
                              TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                  color: redColor,
                                  fontFamily: regular,
                                )
                              ),
                            ]
                          )),
                        )
                      ],
                    ),
                    5.heightBox,
                    controller.isLoading.value 
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      ) 
                    : ourButton(
                      title: signup,
                      color: isChecked == true ? redColor : lightGrey,
                      onPress: () async{
                        if(isChecked != false){
                          controller.isLoading(true);
                          try{
                            await controller
                            .signUpMethod(context: context,email: emailController.text,password: passwordController.text)
                            .then((value){
                              return controller.storeUserData(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text, 
                              );
                            }).then((value) {
                              VxToast.show(context, msg:loggedIn);
                              Get.offAll(()=> const Home());
                              controller.isLoading(false);
                            });
                          }
                          catch(e){
                            auth.signOut();
                            VxToast.show(context, msg: e.toString());
                          }
                        }
                      },
                      textcolor: whiteColor
                    ).box.width(context.screenWidth-50).make(),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        alreadyHaveAccount.text.color(fontGrey).fontFamily(bold).make(),
                        login.text.color(redColor).fontFamily(bold).make().onTap(() {
                          Get.back();
                        }),
                      ],
                    ),
                  ],
                ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth-70).shadowSm.make(),
              ),
            ]
          ),
        ),
      )
    );
  }
}