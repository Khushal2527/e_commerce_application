import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/cart_controllers.dart';
import 'package:e_commerce_application/views/cart_screen/payment_method.dart';
import 'package:e_commerce_application/widgets_common/button.dart';
import 'package:e_commerce_application/widgets_common/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: redColor,
        child: ourButton(
          onPress: (){
            if(controller.addressController.text.length > 10 || controller.cityController.text.isNotEmpty || controller.stateController.text.isNotEmpty || controller.postalCodeController.text.isNotEmpty || controller.phoneController.text.isNotEmpty ){
              Get.to(()=> const PaymentMethod());
            }
            else {
              VxToast.show(context, msg: " Fill the Form");
            }
          },
          color: redColor,
          textcolor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            customTextField(hint: "Address",isPass: false,title: "Address",controller: controller.addressController),
            customTextField(hint: "City",isPass: false,title: "City",controller: controller.cityController),
            customTextField(hint: "State",isPass: false,title: "State",controller: controller.stateController),
            customTextField(hint: "Postal Code",isPass: false,title: "Postal code",controller: controller.postalCodeController),
            customTextField(hint: "Phone",isPass: false,title: "Phone",controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}