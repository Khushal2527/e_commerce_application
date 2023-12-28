import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/consts/lists.dart';
import 'package:e_commerce_application/controllers/product_controllers.dart';
import 'package:e_commerce_application/views/category_screen/category_details.dart';
import 'package:e_commerce_application/widgets_common/bg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});


  @override
  Widget build(BuildContext context) {
  var controller = Get.find<ProductController>();
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: whiteColor,
          ),
          elevation: 0.0,
          title: categories.text.color(whiteColor).fontFamily(bold).make(),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 200
            ),
            itemBuilder: (context,index){
              return Column(
                children: [
                  Image.asset(categoryImages[index],height: 120,width: 200,fit: BoxFit.cover,),
                  10.heightBox,
                  categoryList[index].text.color(darkFontGrey).align(TextAlign.center).make()
                ],
              ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make().onTap(() {
                controller.getSubCategories(categoryList[index]);
                Get.to(CategoryDetails(title: categoryList[index]));
              });
            }
          ),
        ),
      )
    );
  }
}