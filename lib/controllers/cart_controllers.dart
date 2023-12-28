import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/controllers/home_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController{
  var totalP = 0.obs;

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;

  var products =[];

  var placingOrder = false.obs;
  var vendors = [];
  
  calculate (data) {
    totalP.value = 0;
    for( var i = 0 ; i<data.length; i++ ){
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString() );
    }
  }

  changePaymentIndex (index){
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {

    placingOrder(true);

    await getProductDetails();

    var orderCode = await getNextOrderID();

    await firestore.collection(ordersCollection).doc().set({
      'order_code': orderCode,
      'order_date': FieldValue.serverTimestamp(),
      'order_by' : currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email':currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_postalcode': postalCodeController.text,
      'order_by_phone': phoneController.text,
      "shipping_method": "Home Delivery",
      "payment_method": orderPaymentMethod,
      "order_placed": true,
      "order_confirmed": false,
      "order_delivered": false,
      "order_on_delivery":false,
      'total_amount': totalAmount,
      'orders':FieldValue.arrayUnion(products),
      'vendors':FieldValue.arrayUnion(vendors),

    });
    placingOrder(false);
  }

  Future<String> getNextOrderID() async {
    // Query for the most recent order
    QuerySnapshot querySnapshot = await firestore.collection(ordersCollection).orderBy('order_code', descending: true).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      String lastOrderID = querySnapshot.docs.first['order_code'];
      // Extract the numeric part of the order ID
      int lastOrderNumber = int.parse(lastOrderID.replaceAll(RegExp(r'\D+'), ''));
      // Increment the order number
      int nextOrderNumber = lastOrderNumber + 1;
      // Create the next order ID
      String nextOrderID = '00000$nextOrderNumber';

      return nextOrderID;
    }
    else {
      // If no orders exist, start from Order_1
      return '000001';
    }
  }

  getProductDetails(){
    products.clear();
    vendors.clear();
    for(var i = 0;i < productSnapshot.length ; i++ ){
      products.add({
        'color':productSnapshot[i]['color'],
        'img':productSnapshot[i]['img'],
        'qty':productSnapshot[i]['qty'],
        'vendor_id':productSnapshot[i]['vendor_id'],
        'tprice':productSnapshot[i]['tprice'],
        'title':productSnapshot[i]['title'],
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
  }

  clearCart(){
    for(var i =0; i < productSnapshot.length ; i++){
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }


}