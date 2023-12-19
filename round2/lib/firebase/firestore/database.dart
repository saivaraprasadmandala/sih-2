import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseFunctions {
  Future<void> addProductDetails(
    String title,
    String description,
    String material,
    int quantity,
    String quality,
    double length,
    double breadth,
    double height,
    String colour,
    String city,
    double price,
  ) async {
    await FirebaseFirestore.instance.collection('Products').add({
      "title": title,
      "description": description,
      "material": material,
      "quantity": quantity,
      "quality": quality,
      "length": length,
      "breadth": breadth,
      "height": height,
      "colour": colour,
      "city": city,
      "timeStamp": Timestamp.now()
    });
  }

  Future<Stream<QuerySnapshot>> getProducts() async {
    return FirebaseFirestore.instance.collection('Products').snapshots();
  }

  Future<Stream<QuerySnapshot>> userProducts() async {
    String? email = FirebaseAuth.instance.currentUser!.email;
    return FirebaseFirestore.instance
        .collection('Products')
        .where("email", isEqualTo: email)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getProductsInLocation(String city) async {
    return FirebaseFirestore.instance
        .collection('Products')
        .where("city", isEqualTo: city)
        .snapshots();
  }
}
