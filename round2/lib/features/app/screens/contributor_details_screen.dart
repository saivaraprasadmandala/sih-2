import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:round2/constants/styles/text_widget.dart';
import 'package:round2/features/app/screens/home_screen.dart';

class ContributorDetailsScreen extends StatefulWidget {
  const ContributorDetailsScreen({
    super.key,
    required this.description,
  });

  final String description;

  @override
  State<ContributorDetailsScreen> createState() =>
      _ContributorDetailsScreenState();
}

class _ContributorDetailsScreenState extends State<ContributorDetailsScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();

  @override
  void dispose() {
    _fnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  void _addDataToFirestore() {
    String? email = FirebaseAuth.instance.currentUser!.email;
    print(email);
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userId = userDoc.id;

        // Adding data to 'contributions' subcollection
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('contributions')
            .add({
          'fullname': _fnameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'units': _unitsController.text.trim(),
          'address': _addressController.text.trim(),
          // Add other fields similarly
        }).then((value) {
          // Data added successfully
          print('Data added to Firestore');
          // Perform any other actions you want after data is added
        }).catchError((error) {
          // Error handling
          print('Failed to add data: $error');
        });
      } else {
        print('User not found');
        // Handle the case where the user document is not found
      }
    }).catchError((error) {
      // Error handling
      print('Error: $error');
    });

    FirebaseFirestore.instance
        .collection('Products')
        .where('description', isEqualTo: widget.description)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userId = userDoc.id;

        // Adding data to 'contributions' subcollection
        FirebaseFirestore.instance
            .collection('Products')
            .doc(userId)
            .collection('contributors')
            .add({
          'fullname': _fnameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'units': _unitsController.text.trim(),
          'address': _addressController.text.trim(),
          // Add other fields similarly
        }).then((value) {
          // Data added successfully
          print('Data added to Firestore');
          // Perform any other actions you want after data is added
        }).catchError((error) {
          // Error handling
          print('Failed to add data: $error');
        });
      } else {
        print('User not found');
        // Handle the case where the user document is not found
      }
    }).catchError((error) {
      // Error handling
      print('Error: $error');
    });
  }

  void updateQuantity() {
    int newQuantity = int.parse(_unitsController.text.trim());
    final CollectionReference productsCollection =
        FirebaseFirestore.instance.collection('Products');

    productsCollection
        .where('description', isEqualTo: widget.description)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot productDoc = querySnapshot.docs.first;

        if (productDoc.exists) {
          Map<String, dynamic>? data =
              productDoc.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey('quantity')) {
            int currentQuantity = data['quantity'] as int? ?? 0;

            int updatedQuantity = currentQuantity - newQuantity;

            productsCollection
                .doc(productDoc.id)
                .update({'quantity': updatedQuantity}).then((value) {
              print('Quantity updated successfully');
              // Perform actions after updating quantity
            }).catchError((error) {
              print('Failed to update quantity: $error');
              // Handle error
            });
          } else {
            print('Quantity data not found');
            // Handle case where 'quantity' field is missing or null
          }
        } else {
          print('Document does not exist');
          // Handle case where document doesn't exist
        }
      } else {
        print('Product not found');
        // Handle case where product is not found
      }
    }).catchError((error) {
      print('Error: $error');
      // Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const HomeScreen();
                },
              ),
            );
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Enter your details",
          style: TextStyleWidget.headLineTextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Full Name",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _fnameController,
                  decoration: InputDecoration(
                    hintText: "Enter your fullname",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "email",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Phone",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: "Enter your phone number",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Quantity of your contribution",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _unitsController,
                  decoration: InputDecoration(
                    hintText: "Enter your fullname",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Address",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _addressController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Enter your full address",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      _addDataToFirestore();
                      updateQuantity();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('Contribute')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
