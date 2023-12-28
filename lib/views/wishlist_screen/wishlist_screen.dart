import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/services/firestore_services.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlist(), 
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          }
          else if(snapshot.data!.docs.isEmpty){
            return "No Items in wishlist".text.color(darkFontGrey).makeCentered();
          }
          else{
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        leading: Image.network(
                          data[index]['p_images'][0],
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        title: "${data[index]['p_name']}".text.fontFamily(semibold).size(16).make(),
                        subtitle: "${data[index]['p_price']}".text.color(redColor).fontFamily(semibold).size(16).make(),
                        trailing: const Icon(
                          Icons.favorite,
                          color: redColor,
                        ).onTap(() async {
                          await firestore.collection(productsCollection).doc(data[index].id).set({
                            'p_wishlist':FieldValue.arrayRemove([currentUser!.uid]),
                          },SetOptions(merge: true));
                        }),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }
      ),
    );
  }
}