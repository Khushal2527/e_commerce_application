import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/models/category_model.dart';
import 'package:e_commerce_application/services/firestore_services.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  
  
  @override
  void onInit() {
    super.onInit();
    getCartproducts();
  }

  var subCat = [];

  var quantity =  0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var isFav = false.obs;
  var selectedCategory = "".obs ;
  var cartProductId = [].obs;

  getCartproducts() async {
    var streamData = await  FirestoreServices.getCart(currentUser!.uid).get();
    print(streamData.docs);
    streamData.docs.forEach((doc){
      print(doc.toString());
      print(doc['Id']);
      cartProductId.add(doc['Id']);
    });
  }

  getCartField(pid) async {
    var streamData = await FirestoreServices.getCart(currentUser!.uid).get();
    streamData.docs.forEach((doc){
      if(doc["Id"] == pid){
        quantity.value = doc["qty"];
        colorIndex.value = doc["color"];
      }
    });
  }

  inCart(pid){
    if(cartProductId.contains(pid)){
      print("true");
      print(cartProductId);
      return true;
    }
    else{
      print("false");
      print(cartProductId);
      return false;
    }
  }


  getSubCategories(title) async {
    subCat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s  = decoded.categories.where((element) => element.name == title).toList();
    for(var e in s[0].subCategory){
      subCat.add(e);
    }
  }

  changeColorIndex(index){
    colorIndex.value = index;
  }

  increseQuantity(totalQuantity){
    if(quantity.value < totalQuantity ){
      quantity.value++;
    }
  }

  decreaseQuantity(){
    if(quantity.value > 0){
      quantity.value--;
    }
  }

  removeFromCart(pid) async {
    var stream = await firestore.collection(cartCollection).where('Id',isEqualTo: pid).get();
    stream.docs.forEach((data){
      FirestoreServices.deleteDocument(data.id);
      print("removed");
    });
  }

  calculateTotalPrice(price){
    totalPrice.value = price * quantity.value;
  }

  addToCart({ context,pid,title, img, sellername , color, qty, tprice,vendorId }) async {
    await firestore.collection(cartCollection).doc().set({
      "Id":pid,
      'title':title,
      'img':img,
      'sellername':sellername,
      'color':color,
      'qty':qty,
      'tprice':tprice,
      'vendor_id':vendorId,
      'added_by': currentUser!.uid,
    }).catchError((error){
      VxToast.show(context, msg: error.toString());
    });
  }

  resetValues(){
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishlist(context, docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to Wishlist");
  }

  removeFromWishlist(context,docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from Wishlist");
  }

  checkIfFav(data) async{
    if(data['p_wishlist'].contains(currentUser!.uid) ){
      isFav(true);
    }
    else{
      isFav(false);
    }
  }

}