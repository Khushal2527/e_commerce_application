// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/consts/lists.dart';
import 'package:e_commerce_application/controllers/cart_controllers.dart';
import 'package:e_commerce_application/views/home_screen/home.dart';
import 'package:e_commerce_application/widgets_common/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Choose Payment Method".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      bottomNavigationBar: Obx( ()=>
        Container(
          color: redColor,
          width: 60,
          child: controller.placingOrder.value ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(redColor),
            )) 
            : ourButton(
            onPress: () async {
              controller.placeMyOrder(
                orderPaymentMethod: paymentMethod[controller.paymentIndex.value],
                totalAmount: controller.totalP.value
              );
              await controller.clearCart();
              VxToast.show(context, msg: "Order Placed Successfully");
              Get.offAll(const Home());
            },
            color: redColor,
            textcolor: whiteColor,
            title: "Place My Order"
          )
          
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() => Column(
            children: List.generate(paymentMethodsImg.length, (index) {
              return GestureDetector(
                onTap: (){
                  controller.changePaymentIndex(index); 
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: controller.paymentIndex.value == index ? redColor : Colors.transparent,
                      width: 2,
                    )
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children:[
                      Image.asset(
                        paymentMethodsImg[index],
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        color: controller.paymentIndex == index ? Colors.black.withOpacity(0.4) : Colors.transparent,
                        colorBlendMode: controller.paymentIndex == index ? BlendMode.darken : BlendMode.color,
                      ),
                      controller.paymentIndex == index ? Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          activeColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                          ),
                          value: true, 
                          onChanged: (value){}
                        ),
                      ) 
                      : Container(),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: paymentMethod[index].text.white.make()
                      )
                    ] 
                  )),
              );
              }
            )
          ),
        ),
      ),
    );
  }
}