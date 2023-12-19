import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:round2/constants/styles/text_widget.dart';
import 'package:round2/features/app/screens/home_screen.dart';
import 'package:round2/features/app/widgets/loading.dart';
import 'package:round2/firebase/firestore/database.dart';

class UploadRequirement extends StatefulWidget {
  const UploadRequirement({super.key});

  @override
  State<UploadRequirement> createState() => _UploadRequirementState();
}

class _UploadRequirementState extends State<UploadRequirement> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _qualityController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _breadthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _colourController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool uploading = false;
  User? user = FirebaseAuth.instance.currentUser;
  String? value;
  final List<String> items = [
    "Plastic",
    "Glass",
    "Fabric",
    "Wood",
    "Metal",
    "Paper",
    "others",
  ];

  String city = "";
  Stream? itemsStream;

  @override
  void initState() {
    super.initState();
    _initializeItemsStream();
  }

  void _initializeItemsStream() async {
    String c = await _requestLocationPermission();
    // print(c);
    itemsStream = await DatabaseFunctions().getProductsInLocation(c);
    setState(() {});
  }

  Future<String> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        city = placemark.locality ?? "";
      } else {
        //error
      }
    } catch (e) {
      //print("Error: $e");
    }
    return city;
  }

  Future<String> _requestLocationPermission() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    String c = await _getCurrentLocation();
    return c;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _qualityController.dispose();
    _lengthController.dispose();
    _breadthController.dispose();
    _heightController.dispose();
    _colourController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> uploadItem() async {
    if (_titleController.text.trim() != "" &&
        _descriptionController.text.trim() != "" &&
        _quantityController.text.trim() != "" &&
        _qualityController.text.trim() != "" &&
        _lengthController.text.trim() != "" &&
        _breadthController.text.trim() != "" &&
        _heightController.text.trim() != "" &&
        _colourController.text.trim() != "" &&
        _priceController.text.trim() != "" &&
        value != null) {
      setState(() {
        uploading = true; // Start uploading
      });

      try {
        double price = double.tryParse(_priceController.text.trim()) ?? 0.0;
        int quantity = int.parse(_quantityController.text.trim());

        await FirebaseFirestore.instance.collection("Products").add(
          {
            "title": _titleController.text.trim(),
            "description": _descriptionController.text.trim(),
            "material": value,
            "quantity": quantity,
            "quality": _qualityController.text.trim(),
            "length": _lengthController.text.trim(),
            "breadth": _breadthController.text.trim(),
            "height": _heightController.text.trim(),
            "colour": _colourController.text.trim(),
            "city": city,
            "price": price,
            "timeStamp": Timestamp.now()
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product Uploaded Successfully"),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload product"),
          ),
        );
      } finally {
        setState(() {
          uploading = false; // Stop uploading
        });
      }
    }
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
          "Add Product Requirements",
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
              Text(
                "Upload the Product details",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Product Name",
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
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "Enter product name",
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
                "Product Description",
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
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Enter Product Description",
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
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style:
                                  TextStyleWidget.subHeadLineTextFieldStyle(),
                            )))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: const Text("Select Material"),
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Product Quantity",
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
                  controller: _quantityController,
                  decoration: InputDecoration(
                    hintText: "Enter Product Quantity",
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
                "Product Quality",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _qualityController,
                  decoration: InputDecoration(
                    hintText: "Enter Product Quality",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Product length",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _lengthController,
                  decoration: InputDecoration(
                    hintText: "Enter Product length (in cm)",
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
                "Product breadth",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _breadthController,
                  decoration: InputDecoration(
                    hintText: "Enter Product breadth (in cm)",
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
                "Product height",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _heightController,
                  decoration: InputDecoration(
                    hintText: "Enter Product height (in cm)",
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
                "Product Colour",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _colourController,
                  decoration: InputDecoration(
                    hintText: "Enter Product Colour",
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
                "Product Price",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: "Enter Product price",
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
                child: uploading
                    ? const Loading()
                    : ElevatedButton(
                        onPressed: () {
                          uploadItem();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
