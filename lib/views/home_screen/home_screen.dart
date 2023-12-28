// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/consts/lists.dart';
import 'package:e_commerce_application/controllers/home_controllers.dart';
import 'package:e_commerce_application/controllers/product_controllers.dart';
import 'package:e_commerce_application/services/firestore_services.dart';
import 'package:e_commerce_application/views/category_screen/item_details.dart';
import 'package:e_commerce_application/views/home_screen/components/featured_buttons.dart';
import 'package:e_commerce_application/views/home_screen/components/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    var productController = Get.put(ProductController());
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: const Icon(Icons.search).onTap(() { 
                    if(controller.searchController.text.isNotEmptyAndNotNull){
                      Get.to(()=> Search(title: controller.searchController.text,));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchAnything,
                  hintStyle: const TextStyle(
                    color: textfieldGrey,
                  )
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VxSwiper.builder(
                      aspectRatio: 16/9,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      height: 150,
                      itemCount: slidersList.length,
                      itemBuilder: (context,index){
                        return Image.asset(slidersList[index],fit: BoxFit.fill,).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make();
                      }
                    ),
                    10.heightBox,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: featuredCategories.text.color(darkFontGrey).size(18).fontFamily(semibold).make()
                    ),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(3, (index) => Column(
                          children: [
                            featuredButtons(title: featuredTitle1[index],icon: featuredList1[index]),
                            10.heightBox,
                            featuredButtons(title: featuredTitle2[index],icon: featuredList2[index]),
                          ],
                        )).toList(),
                      ),
                    ),
                    20.heightBox,
                    VxSwiper.builder(
                      aspectRatio: 16/9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context,index){
                        return Image.asset(
                          secondSlidersList[index],
                          fit: BoxFit.cover,
                        ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make();
                      }
                    ),
                    20.heightBox,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: featuredProducts.text.color(darkFontGrey).size(18).fontFamily(semibold).make()
                    ),
                    20.heightBox,
                    StreamBuilder(
                      stream: FirestoreServices.getFeaturedProducts(), 
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(!snapshot.hasData){
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(redColor),
                            ),
                          );
                        }
                        else{
                          var featuredProductsdata = snapshot.data!.docs;
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: featuredProductsdata.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              mainAxisExtent: 300,
                            ), 
                            itemBuilder: (context,index){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(featuredProductsdata[index]["p_images"][0],height: 200,width: 200,fit: BoxFit.fill,),
                                  const Spacer(),
                                  featuredProductsdata[index]["p_name"].toString().text.capitalize.fontFamily(semibold).color(darkFontGrey).make(),
                                  10.heightBox,
                                  featuredProductsdata[index]["p_price"].toString().text.fontFamily(semibold).color(redColor).size(16).make(),
                                  10.heightBox,
                                ],
                              ).box.white.margin(const EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(const EdgeInsets.symmetric(horizontal: 12)).make().onTap(() {
                                Get.to(()=> ItemDetails(title: featuredProductsdata[index]['p_name'],data: featuredProductsdata[index],));
                              });
                            }
                          );
                        }
                      }
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}