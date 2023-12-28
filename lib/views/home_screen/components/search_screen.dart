import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/services/firestore_services.dart';
import 'package:e_commerce_application/views/category_screen/item_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Search extends StatelessWidget {
  final String? title;
  const Search({
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).make(),
      ),
      body: FutureBuilder(
        future: FirestoreServices.searchProdusts(title),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          }
          else if(snapshot.data!.docs.isEmpty) {
            return "No products found".text.makeCentered();
          }
          else{
            var data = snapshot.data!.docs;
            var filteredData = data.where((element)=> element['p_name'].toString().toLowerCase().contains(title!.toLowerCase())).toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 320,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8
                ),
                children: filteredData.mapIndexed((currentValue, index) =>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        filteredData[index]['p_images'][0],
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const Spacer(),
                      "${filteredData[index]['p_name']}".text.color(darkFontGrey).fontFamily(semibold).make(),
                      10.heightBox,
                      "${filteredData[index]['p_price']}".text.color(redColor).fontFamily(semibold).size(16).make(),
                      10.heightBox
                    ],
                  ).box.white.outerShadowMd.margin(const EdgeInsets.all(4)).roundedSM.padding(const EdgeInsets.all(12)).make().onTap(() {
                    Get.to(()=> ItemDetails(title: data[index]['p_name'],data: data[index],));
                  })
                ).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}