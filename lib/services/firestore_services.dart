import 'package:e_commerce_application/consts/consts.dart';

class FirestoreServices{
  static getUser(uid){
    return firestore.collection(userCollection).where('id',isEqualTo: uid).snapshots();
  }

  static getProducts(category){
    return firestore.collection(productsCollection).where('p_category',isEqualTo: category).snapshots();
  }

  static getCart(uid){
    return firestore.collection(cartCollection).where('added_by',isEqualTo: uid);
  }

  static deleteDocument(docId){
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  static getChatMessages(docId){
    return firestore.collection(chatsCollection).doc(docId).collection(messageCollection).orderBy('created_on',descending: false).snapshots();
  }

  static getAllOrders(){
    return firestore.collection(ordersCollection).where('order_by',isEqualTo: currentUser!.uid).snapshots();
  }

  static getWishlist(){
    return firestore.collection(productsCollection).where('p_wishlist',arrayContains: currentUser!.uid).snapshots();
  }

  static getAllMessages(){
    print(currentUser!.uid);
    return firestore.collection(chatsCollection).where('fromId',isEqualTo: currentUser!.uid).snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      firestore.collection(cartCollection).where('added_by',isEqualTo: currentUser!.uid).get().then((value) {
       return value.docs.length;
      }),
      firestore.collection(productsCollection).where('p_wishlist',arrayContains: currentUser!.uid).get().then((value) {
       return value.docs.length;
      }),
      firestore.collection(ordersCollection).where('order_by',isEqualTo: currentUser!.uid).get().then((value) {
       return value.docs.length;
      })
    ]);
    return res;
  }

  static allProducts(){
    return firestore.collection(productsCollection).snapshots();
  }

  static getFeaturedProducts(){
    return firestore.collection(productsCollection).where('is_featured',isEqualTo: true).snapshots();
  }

  static searchProdusts(title){
    return firestore.collection(productsCollection).get();
  }

  static getSubCategory (title){
    return firestore.collection(productsCollection).where('p_subcategory',isEqualTo: title).snapshots();
  }


}

