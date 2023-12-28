import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/cart_controllers.dart';
import 'package:e_commerce_application/controllers/product_controllers.dart';
import 'package:e_commerce_application/services/firestore_services.dart';
import 'package:e_commerce_application/views/cart_screen/shipping_screen.dart';
import 'package:e_commerce_application/widgets_common/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    var productController = Get.find<ProductController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: "Shopping cart".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid).snapshots(), 
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          }
          else if(snapshot.data!.docs.isEmpty){
            return Center(
              child: "Cart is Empty".text.color(darkFontGrey).make()
            );
          }
          else{
            var data = snapshot.data!.docs;
            controller.productSnapshot = data;
            controller.calculate(data);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          leading: Image.network('${data[index]['img']}',width: 80,fit: BoxFit.cover,),
                          title: "${data[index]['title']}(×${data[index]['qty']}) ".text.capitalize.fontFamily(semibold).size(16).make(),
                          subtitle: "${data[index]['tprice']}".numCurrency.text.color(redColor).fontFamily(semibold).make(),
                          trailing: const Icon(Icons.delete,color: redColor).onTap(() {
                            // print(productController.cartProductId);
                            productController.cartProductId.remove(data[index]["Id"]);
                            // print(productController.cartProductId);
                            FirestoreServices.deleteDocument(data[index].id);
                          }),
                        );
                      }
                    ) 
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total Price".text.fontFamily(semibold).color(darkFontGrey).make(),
                      Obx( ()=>  
                        "${controller.totalP.value}".numCurrency.text.fontFamily(semibold).color(redColor).make()
                      ),
                    ],
                  ).box.width(context.screenWidth-60).padding(const EdgeInsets.all(12)).color(lightGolden).roundedSM.make(),
                  10.heightBox,
                  Container(
                    color: redColor,
                    height: 60,
                    width: context.screenWidth-60,
                    child: ourButton(
                      color: redColor,
                      onPress: (){
                        Get.to(const ShippingDetails());
                      },
                      textcolor: whiteColor,
                      title: "Proceed for shipping"
                    )
                  ),
                ],
              ),
            );
          }
        }
      )
    );
  }
}