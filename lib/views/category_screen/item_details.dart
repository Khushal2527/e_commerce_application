import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/product_controllers.dart';
import 'package:e_commerce_application/views/chat_screen/chat_screen.dart';
import 'package:e_commerce_application/widgets_common/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetails extends StatelessWidget {

  final String? title;
  final dynamic data;

  const ItemDetails({
    super.key,
    required this.title,
    this.data,
  });

  @override

  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    if(controller.inCart(data.id) == true){
      controller.getCartField(data.id);
    }
    if(controller.inCart(data.id) == false){
      controller.resetValues();
    }
    return WillPopScope(
      onWillPop: () async {
        if(controller.inCart(data.id) == false ){
          controller.resetValues();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              if(controller.inCart(data.id) == false ){
                controller.resetValues();
              }
              Get.back();
            }, 
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: title!.text.capitalize.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
              onPressed: (){}, 
              icon: const Icon(Icons.share)
            ),
            Obx( ()=> 
              IconButton(
                onPressed: (){
                  print(data.toString());
                  if( controller.isFav.value ){
                    controller.removeFromWishlist(context,data.id);
                    controller.isFav(false);
                  }
                  else{
                    controller.addToWishlist(context,data.id);
                    controller.isFav(true);
                  }
                }, 
                icon: Icon(
                  Icons.favorite_outlined,
                  color: controller.isFav.value ? redColor : darkFontGrey,
                
                )
              ),
            ),
          ],
        ),
        backgroundColor: whiteColor,
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VxSwiper.builder(
                        autoPlay: true,
                        aspectRatio: 16/9,
                        height: 350,
                        viewportFraction: 1.0,
                        itemCount: data['p_images'].length,
                        itemBuilder: (context,index){
                          return Image.network(
                            data['p_images'][index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }
                      ),
                      10.heightBox,
                      title!.text.capitalize.size(16).fontFamily(semibold).make(),
                      10.heightBox,
                      VxRating(
                        isSelectable: true,
                        value: double.parse(data['p_rating']),
                        onRatingUpdate: (value){},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                        size: 25,
                        maxRating: 5,
                      ),
                      10.heightBox,
                      '${data['p_price']}'.numCurrency.text.color(redColor).fontFamily(bold).size(18).make(),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Seller".text.white.fontFamily(semibold).make(),
                                10.heightBox,
                                '${data['p_seller']}'.text.capitalize.fontFamily(semibold).color(darkFontGrey).size(16).make(),
                              ],
                            )
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.message_rounded,color: darkFontGrey,),
                          ).onTap(() {
                            Get.to( () => const ChatScreen(),arguments: [data['p_seller'],data['vendor_id']]);
                          })
                        ],
                      ).box.height(60).padding(const EdgeInsets.symmetric(horizontal: 16)).color(textfieldGrey).make(),
                      20.heightBox,
                      Obx( 
                        () => Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Color".text.color(textfieldGrey).make(),
                                ),
                                Row(
                                  children: List.generate(
                                    data['p_colors'].length,
                                    (index) => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        VxBox()
                                          .size(40, 40)
                                          .roundedFull
                                          .color(Color(data['p_colors'][index]).withOpacity(1.0))
                                          .margin(const EdgeInsets.symmetric(horizontal: 4))
                                          .make().onTap(() {
                                            controller.changeColorIndex(index);
                                          }),
                                        Visibility(
                                          visible: index == controller.colorIndex.value,
                                          child: const Icon(Icons.done,color: Colors.white,)
                                        )
                                      ],
                                    )
                                    ),
                                )
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make()
                          ],
                        ).box.white.make(),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: "Quantity".text.color(textfieldGrey).make(),
                          ),
                          Obx( 
                            () => Row(
                              children: [
                                IconButton(onPressed: (){
                                  controller.decreaseQuantity();
                                  controller.calculateTotalPrice(int.parse( data['p_price']));
                                }, icon:const Icon(Icons.remove)),
                                controller.quantity.value.text.size(16).fontFamily(semibold).color(darkFontGrey).make(),
                                IconButton(onPressed: (){
                                  controller.increseQuantity(int.parse(data['p_quantity']));
                                  controller.calculateTotalPrice( int.parse( data['p_price']));
                                }, icon:const Icon(Icons.add)),
                                10.widthBox,
                              ],
                            ),
                          )
                        ],
                      ).box.padding(const EdgeInsets.all(8)).make(),
                      10.heightBox,
                      "Description".text.fontFamily(semibold).color(darkFontGrey).make(),
                      10.heightBox,
                      "${data['p_desc']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                      20.heightBox,
                    ],
                  ),
                ),
              )
            ),
            Obx(()=>
              Container(
                color: redColor,
                width: double.infinity,
                height: 60,
                child: ourButton(
                  color: redColor,
                  onPress: (){
                    if(controller.inCart(data.id) == false){
                      if(controller.quantity.value > 0){
                        controller.addToCart(
                          pid: data.id , 
                          title: data['p_name'],
                          color: data['p_colors'][controller.colorIndex.value],
                          context: context,
                          img: data['p_images'][0],
                          qty: controller.quantity.value,
                          vendorId: data['vendor_id'],
                          sellername: data['p_seller'],
                          tprice: controller.totalPrice.value,
                        );
                        controller.cartProductId.add(data.id);
                        print(controller.cartProductId);
                        VxToast.show(context, msg: "Added to cart");
                      }
                      else{
                        VxToast.show(context, msg: "Increase the quantity to atleast 1");
                      }
                    }
                    else{
                      print(data.id);
                      controller.removeFromCart(data.id);
                      controller.cartProductId.remove(data.id);
                      VxToast.show(context, msg: "Removed from cart");
                    }
                  },
                  title: controller.inCart(data.id) == true ? "Remove from cart" : addToCart,
                  textcolor: whiteColor
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}