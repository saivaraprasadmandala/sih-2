// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:round2/constants/functions/functions.dart';

class FirebaseAuthFunctions {
  void registerUser(BuildContext context, String uname, String email,
      String password, String cpassword) async {
    Future<void> addUserDetails(String username, String email) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            "uname": username,
            "email": email,
            "uid": user.uid,
          });
        } else {
          // Handle the case where user is null (not signed in)
          //print("User is not signed in");
        }
      } catch (e) {
        //print("Error adding user details: $e");
        // Handle the error as needed
      }
    }

    if (uname.isNotEmpty &&
        email.isNotEmpty &&
        password == cpassword &&
        password.length >= 8) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        addUserDetails(
          uname,
          email,
        );
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context, "Invalid Input", e.code);
      } catch (e) {
        //print("something bad happened");
        //print(e.runtimeType); //this will give the type of exception that occured
        //print(e);
      }
    } else if (uname.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter username");
    } else if (email.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter your email");
    } else if (!email.contains('@')) {
      showAlertDialog(context, "Invalid Input", "please enter correct email");
    } else if (!email.contains('@')) {
      showAlertDialog(context, "Invalid Input", "please enter correct email");
    } else if (password.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter password");
    } else if (password.length < 8) {
      showAlertDialog(context, "Invalid Input",
          "password length must be minimum of 8 characters");
    } else if (password != cpassword) {
      showAlertDialog(context, "Invalid Input",
          "password and confirm password are not same");
    }
  }

  void signinUser(BuildContext context, String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context, "Invalid Input", e.code);
      } catch (e) {
        // print("something bad happened");
        // print(e
        //     .runtimeType); //this will give the type of exception that occured
        // print(e);
      }
    } else if (email.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter email");
    } else if (password.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter password");
    }
  }

  // void resetPassword(BuildContext context, String email) async {
  //   try {
  //     if (email.isNotEmpty) {
  //       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: const Text("Password Reset"),
  //             content: const Text(
  //                 "A password reset link has been sent to your email.\nIF YOU CAN'T FIND THE LINK THEN CHECK YOUR SPAM."),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                   Navigator.of(context).push(
  //                     MaterialPageRoute(
  //                       builder: (builder) => const SigninScreen(),
  //                     ),
  //                   );
  //                 },
  //                 child: const Text(
  //                   'OK',
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       showAlertDialog(
  //           context, "Invalid Input", "Please enter your registered email.");
  //     }
  //   } catch (e) {
  //     showAlertDialog(context, "Error", "Failed to reset password.");
  //   }
  // }

  // Future<void> signOutUser(BuildContext context) async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => const SignupScreen(),
  //       ),
  //     );
  //     //print("Sign out successful!");
  //   } catch (e) {
  //     //print("An unexpected error occurred during sign-out. Error: $e");
  //   }
  // }

  // Future<void> deleteAccount(BuildContext context) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? currentUser = auth.currentUser;

  //   if (currentUser != null) {
  //     // Step 1: Delete the 'cart' subcollection
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUser.uid)
  //         .collection('cart')
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       for (var doc in querySnapshot.docs) {
  //         doc.reference.delete();
  //       }
  //     });

  //     // Step 2: Delete the user document from 'users' collection
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUser.uid)
  //         .delete();

  //     // Step 3: Delete user from Firebase Authentication
  //     await currentUser.delete();

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => const SignupScreen(),
  //       ),
  //     );
  //   } else {
  //     // Handle the case where the current user is null (not signed in)
  //     //print('User is not signed in.');
  //   }
  // }
}
