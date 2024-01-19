import 'package:e_commerce_application/consts/consts.dart';
import 'package:e_commerce_application/views/orders_screen/components/order_status.dart';
import 'package:e_commerce_application/views/orders_screen/order_place_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl ;

class OrdersDetails extends StatelessWidget {
  const OrdersDetails({
    super.key,
    required this.data,
  });

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "OrderDetails".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              orderStatus(color: redColor,icon: Icons.done, title: "Placed",showDone: data["order_placed"] ),
              orderStatus(color: Colors.blue,icon: Icons.thumb_up, title: "Confirmed",showDone: data["order_confirmed"] ),
              orderStatus(color: Colors.yellow,icon: Icons.car_crash, title: "On Delivery",showDone: data["order_on_delivery"] ),
              orderStatus(color: Colors.purple,icon: Icons.done_all_rounded, title: "Delivered",showDone: data["order_delivered"]),
              const Divider(),
              10.heightBox,
              Column(
                children: [
                  orderPlaceDetails(
                    d1: data['order_code'],
                    d2: data['shipping_method'],
                    title1: "Order Code",
                    title2: "Shipping method"
                  ),
                  orderPlaceDetails(
                    d1: intl.DateFormat().add_yMd().format(data['order_date'].toDate()),
                    d2: data['payment_method'],
                    title1: "Order date",
                    title2: "Payment method"
                  ),
                  orderPlaceDetails(
                    d1: "Unpaid",
                    d2: "Order Placed",
                    title1: "Payment Status",
                    title2: "Delivery Status"
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Shipping Address".text.fontFamily(semibold).make(),
                              "${data['order_by_name']}".text.make(),
                              "${data['order_by_email']}".text.make(),
                              "${data['order_by_address']}".text.make(),
                              "${data['order_by_city']}".text.make(),
                              "${data['order_by_state']}".text.make(),
                              "${data['order_by_postalcode']}".text.make(),
                              "${data['order_by_phone']}".text.make(),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(semibold).make(),
                              "${data['total_amount']}".text.color(redColor).fontFamily(bold).make()
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ).box.outerShadowMd.white.make(),
              const Divider(),
              "Ordered Products".text.size(16).color(darkFontGrey).fontFamily(semibold).makeCentered(),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children:
                  List.generate(data['orders'].length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderPlaceDetails(
                          title1: data['orders'][index]['title'],
                          title2: data['orders'][index]['tprice'],
                          d1: "×${data['orders'][index]['qty']}",
                          d2: "Refundable"
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            width: 30,
                            height: 20,
                            color: Color(data['orders'][index]['color']),
                          ),
                        )
                      ],
                    );
                  }).toList(),
              ).box.outerShadowMd.white.margin(const EdgeInsets.only(bottom: 4)).make(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}