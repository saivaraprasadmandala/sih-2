import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:round2/constants/styles/text_widget.dart';
import 'package:round2/features/app/screens/display_screen.dart';
import 'package:round2/features/app/widgets/bottom_nav.dart';
import 'package:round2/features/app/widgets/loading.dart';
import 'package:round2/firebase/firestore/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool plastic = false;
  bool glass = false;
  bool fabric = false;
  bool wood = false;
  bool metal = false;
  bool paper = false;

  Stream? itemStream;

  String uname = '';

  onTheLoad() async {
    itemStream = await DatabaseFunctions().getProducts();
    retrieveUname();
    setState(() {});
  }

  Future<void> retrieveUname() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    try {
      QuerySnapshot userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .get();

      if (userDocs.docs.isNotEmpty) {
        String retrievedUname = userDocs.docs[0]['uname'];

        setState(() {
          uname = retrievedUname;
        });
      }
    } catch (e) {
      //print("Error retrieving data: $e");
    }
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Widget allItemsVertically() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.6,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: itemStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return const Center(child: Text('No items available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailsScreen(
                            name: ds['title'],
                            description: ds['description'],
                            category: ds['material'],
                            price: ds['price'],
                            quantity: ds['quantity'],
                          );
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        ds['title'],
                                        style: TextStyleWidget
                                            .boldTextFieldStyle(),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          ds['description'],
                                          style: TextStyleWidget
                                              .lightTextFieldStyle(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Price : ",
                                            style: TextStyleWidget
                                                .semiBoldTextFieldStyle(),
                                          ),
                                          Text(
                                            ds['price'].toString(),
                                            style: TextStyleWidget
                                                .lightHeadingTextFieldStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello $uname,",
                  style: TextStyleWidget.boldTextFieldStyle(),
                ),
                GestureDetector(
                  onTap: () {
                    // Reload the page here
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const BottomNav(),
                      ),
                    );
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.replay_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Innovative Products",
              style: TextStyleWidget.headLineTextFieldStyle(),
            ),
            Text(
              "Expereince the new gen best out of waste products",
              style: TextStyleWidget.lightTextFieldStyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            showCategory(),
            const SizedBox(
              height: 20,
            ),
            allItemsVertically(),
          ],
        ),
      ),
    );
  }

  // widget to show category of products
  Widget showCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            plastic = true;
            glass = false;
            fabric = false;
            wood = false;
            //itemStream = await HomeDataFirestore().getProduct("Plastic");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: plastic ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/plastic.png',
                  height: 40,
                  width: 40,
                  //color: plastic ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            plastic = false;
            glass = true;
            fabric = false;
            wood = false;
            //itemStream = await HomeDataFirestore().getProduct("Glass");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: glass ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/glass.png',
                  height: 40,
                  width: 40,
                  //color: plastic ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            plastic = false;
            glass = false;
            fabric = true;
            wood = false;
            //itemStream = await HomeDataFirestore().getProduct("Fabric");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: fabric ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/clothes.png',
                  height: 40,
                  width: 40,
                  //color: plastic ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            plastic = false;
            glass = false;
            fabric = false;
            wood = true;
            //itemStream = await HomeDataFirestore().getProduct("Wood");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: wood ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/wood.png',
                  height: 40,
                  width: 40,
                  //color: plastic ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
