import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:userapp/screens/login/signup_screen.dart';

import '../../models/snackbar.dart';
import '../../widgets/button.dart';

class OTPBox extends StatelessWidget {
  final double width;
  final int i;
  const OTPBox({super.key, required this.width, required this.i});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width,
      child: TextFormField(
        onChanged: (value) {
          if (value.isEmpty) {
            OTPScreen.code[i] = "-1";
          }
          if (value.length == 1) {
            OTPScreen.code[i] = value;
            FocusScope.of(context).nextFocus();
          }
        },
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}

class OTPScreen extends StatelessWidget {
  static const routeName = '/otp';
  final auth = FirebaseAuth.instance;
  static List<String> code = List.generate(6, (index) => "-1");
  OTPScreen({super.key});

  String? buildCode() {
    String res = "";
    if (code.contains("-1")) {
      return null;
    }
    for (var i in code) {
      res += i;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final number = args['mobileNo'];
    final verify = args['verificationId'];
    final width = (MediaQuery.sizeOf(context).width - 100) / 6;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: 'We have sent an OTP to your number at ',
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: number.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OTPBox(width: width, i: 0),
                OTPBox(width: width, i: 1),
                OTPBox(width: width, i: 2),
                OTPBox(width: width, i: 3),
                OTPBox(width: width, i: 4),
                OTPBox(width: width, i: 5),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
                width: double.infinity,
                child: CustomFilledButton(
                  onPressed: () async {
                    final s = buildCode();
                    if (s == null) {
                      showSnackbarOnScreen(context, 'Enter Complete OTP');
                    } else {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verify, smsCode: s);
                        await auth.currentUser?.linkWithCredential(credential);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            SignUpScreen.routeName, (route) => false);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-verification-code') {
                          showSnackbarOnScreen(context, 'Wrong OTP');
                        } else if (e.code == 'credential-already-in-use') {
                          showSnackbarOnScreen(context,
                              'Mobile Number has already been registered');
                        }
                      }
                    }
                  },
                  child: const Text("Verify"),
                )),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Change mobile number?",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
