import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:round2/constants/styles/text_widget.dart';
import 'package:round2/features/app/screens/contributor_details_screen.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.name,
    required this.description,
    required this.category,
    required this.quantity,
    required this.price,
  });

  final String name;
  final String description;
  final String category;
  final int quantity;
  final double price;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int count = 1;
  String? email = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20.0,
                top: 50.0,
                right: 20.0,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(widget.name,
                    style: TextStyleWidget.headLineTextFieldStyle()),
                const Spacer(),
                const Icon(
                  Icons.currency_rupee,
                ),
                Text(
                  widget.price.toString(),
                  style: TextStyleWidget.headLineTextFieldStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.description,
              style: TextStyleWidget.lightHeadingTextFieldStyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Product made of : ",
                  style: TextStyleWidget.semiBoldTextFieldStyle(),
                ),
                Text(
                  widget.category,
                  style: TextStyleWidget.lightHeadingTextFieldStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  widget.quantity.toString(),
                  style: TextStyleWidget.semiBoldTextFieldStyle(),
                ),
                Text(
                  ' items left in stock',
                  style: TextStyleWidget.lightHeadingTextFieldStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
            return ContributorDetailsScreen(
              description: widget.description,
            );
          })));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        child: const Text(
          'Want to Contribute?',
        ),
      ),
    );
  }
}
