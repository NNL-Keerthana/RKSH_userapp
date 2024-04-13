import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:userapp/models/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:userapp/screens/login/signup_screen.dart';

import '../base_client.dart';
import '../constants.dart';
import '../screens/home/home.dart';
import '../screens/login/phone.dart';

class SignInWithGoogle extends StatelessWidget {
  const SignInWithGoogle({super.key});

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<bool?> updateFCM() async {
    final url = Uri.parse('${Constants.baseUrl}/user/login_user/');
    String? authToken;
    try {
      authToken = await BaseClient().getAuthToken();
      var fcmToken = await BaseClient().getFCMToken();
      // print(authToken);
      // print(fcmToken);
      var response = await http.post(
        url,
        headers: {
          'Authorization': authToken!,
          'Content-Type': 'application/json'
        },
        body: json.encode({"registrationToken": fcmToken!}),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (response.body.contains('not provided')) {
        return false;
      }
    } on Exception catch (_) {
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () async {
        try {
          await signInWithGoogle();
          final auth = FirebaseAuth.instance;
          if (auth.currentUser!.phoneNumber == null ||
              auth.currentUser!.phoneNumber == "") {
            // User not signed up with his google account.
            Navigator.of(context)
                .pushReplacementNamed(PhoneVerification.routeName);
          } else {
            var b = await updateFCM();
            if (b == null) {
              showSnackbarOnScreen(context, 'Error updating in db');
            } else if (b) {
              Navigator.of(context).pushReplacementNamed(Home.routeName);
            } else {
              Navigator.of(context)
                  .pushReplacementNamed(SignUpScreen.routeName);
            }
          }
        } catch (e) {
          showSnackbarOnScreen(context, 'Please choose a google account');
        }
      },
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black,
      ).copyWith(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      icon: Container(
        height: 24.0,
        width: 24.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/google.png'),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
        ),
      ),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
