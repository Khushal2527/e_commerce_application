import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/auth_controllers.dart';
import 'package:e_commerce_application/views/auth_screen/signup.dart';
import 'package:e_commerce_application/views/home_screen/home.dart';
import 'package:e_commerce_application/widgets_common/applogo_widget.dart';
import 'package:e_commerce_application/widgets_common/bg.dart';
import 'package:e_commerce_application/widgets_common/button.dart';
import 'package:e_commerce_application/widgets_common/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class  LoginScreen extends StatelessWidget {
  const  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(AuthController());

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight*0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(()=>
                Column(
                  children: [
                    customTextField( hint:emailHint, title: email,isPass: false,controller: controller.emailController ),
                    customTextField( hint: passwordHint,title: password ,isPass: true,controller: controller.passwordController),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {},
                        child: forgetPassword.text.make()
                      ),
                    ),
                    5.heightBox,
                    controller.isLoading.value 
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      ) 
                    : ourButton(title: login,color: redColor,onPress: () async {
                        if(controller.emailController.text.isNotEmpty && controller.passwordController.text.isNotEmpty){
                          controller.isLoading(true);
                          await controller.loginMethod(context: context).then((value){
                          if(value != null){
                            print(value);
                            VxToast.show(context, msg: loggedIn);
                            Get.offAll(()=> const Home());
                          }
                          else{
                            controller.isLoading(false);
                            VxToast.show(context, msg: "Check you login details");
                          }
                        });
                        }
                        else{
                          VxToast.show(context, msg: "Enter login details");
                        }
                      },textcolor: whiteColor).box.width(context.screenWidth-50).make(),
                    5.heightBox,
                    createNewAccount.text.color(fontGrey).make(),
                    5.heightBox,
                    ourButton(title: signup,color: lightGolden ,onPress: (){
                      Get.to(()=> const SignUpScreen());
                    },textcolor: redColor).box.width(context.screenWidth-50).make(),
                    10.heightBox,
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