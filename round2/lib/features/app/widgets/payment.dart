import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:round2/constants/variables/razorpay.dart' as constant;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.amount,
    required this.title,
  });

  final double amount;
  final String title;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _razorpay = Razorpay();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();

    createOrder();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // verifySignature(
    //   signature: response.signature,
    //   paymentId: response.paymentId,
    //   orderId: response.orderId,
    // );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const DeliveryTracking(),
    //   ),
    // );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    //print(response);
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message ?? ''),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    //print(response);
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.walletName ?? ''),
      ),
    );
  }

// create order
  void createOrder() async {
    String username = constant.keyId;
    String password = constant.keySecret;
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": widget.amount * 100,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    var res = await http.post(
      Uri.https(
          "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      openGateway(jsonDecode(res.body)['id']);
    }
    //print(res.body);
  }

  openGateway(String orderId) {
    var options = {
      'key': constant.keyId,
      'amount': widget.amount * 100, //in the smallest currency sub-unit.
      'name': 'Resculpt',
      'order_id': orderId, // Generate order_id using Orders API
      'description': widget.title,
      'timeout': 60 * 5, // in seconds // 5 minutes
      // 'prefill': {
      //   'contact': '9123456789',
      //   'email': 'ary@example.com',
      // }
    };
    _razorpay.open(options);
  }

  verifySignature({
    String? signature,
    String? paymentId,
    String? orderId,
  }) async {
    Map<String, dynamic> body = {
      'razorpay_signature': signature,
      'razorpay_payment_id': paymentId,
      'razorpay_order_id': orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.https(
        "10.0.2.2", // my ip address , localhost
        "razorpay_signature_verify.php",
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );

    //print(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body),
        ),
      );
    }
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        // appBar: AppBar(
        //   title: const Text("Razorpay Demo"),
        // ),
        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       ElevatedButton(
        //         onPressed: () {
        //           createOrder();
        //         },
        //         child: const Text("Buy Now"),
        //       )
        //     ],
        //   ),
        // ),
        );
  }
}
