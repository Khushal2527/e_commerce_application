import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/product_controllers.dart';
import 'package:e_commerce_application/services/firestore_services.dart';
import 'package:e_commerce_application/views/category_screen/item_details.dart';
import 'package:e_commerce_application/widgets_common/bg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDetails extends StatefulWidget {

  final String? title;

  const CategoryDetails({
    super.key,
    required this.title,
  });

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title){
    if(controller.subCat.contains(title)){
      productMethod = FirestoreServices.getSubCategory(title);
    }
    else{
      productMethod = FirestoreServices.getProducts(title);
    }
  }
  
  var controller = Get.find<ProductController>();

  dynamic productMethod;
  
  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: whiteColor,
          ),
          elevation: 0.0,
          title: widget.title!.text.fontFamily(bold).color(whiteColor).make(),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.subCat.length,
                  (index) => 
                  "${controller.subCat[index]}".text.size(12).fontFamily(semibold).color(darkFontGrey).makeCentered().box.rounded.white.size(120,60).margin(const EdgeInsets.symmetric(horizontal: 4)).make().onTap(() {
                      switchCategory('${controller.subCat[index]}');
                      setState(() {});
                    }),
                  ),
              ),
            ),
            20.heightBox,
            StreamBuilder(
              stream: productMethod,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){ 
                if(!snapshot.hasData){
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      ),
                    ),
                  );
                } 
                else if(snapshot.data!.docs.isEmpty){
                  return Expanded(
                    child: Center(
                      child: "No products found".text.color(darkFontGrey).make(),
                    ),
                  );
                }
                else{
                  var data = snapshot.data!.docs;
                  return Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8
                      ),
                      itemBuilder: (context,index){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            10.heightBox,
                            Image.network(
                              data[index]['p_images'][0],
                              height: 150,
                              width: 200,
                              fit: BoxFit.fill,
                            ),
                            "${data[index]["p_name"]}".text.capitalize.fontFamily(semibold).color(darkFontGrey).make(),
                            10.heightBox,
                            "${data[index]["p_price"]}".numCurrency.text.fontFamily(semibold).color(redColor).size(16).make(),
                            10.heightBox,
                          ],
                        )
                          .box
                          .white
                          .margin(const EdgeInsets.symmetric(horizontal: 4))
                          .roundedSM
                          .outerShadowSm
                          .padding(const EdgeInsets.symmetric(horizontal: 12))
                          .make()
                          .onTap(() {
                            controller.checkIfFav(data[index]);
                            Get.to(ItemDetails(title: "${data[index]["p_name"]}",data: data[index], ));
                          });
                        }
                      )
                    );
                }
              }
            ),
          ],
        )
      )
    );
  }
}