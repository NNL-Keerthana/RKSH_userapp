import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:userapp/screens/login/otp.dart';

import '../../constants.dart';
import '../../models/snackbar.dart';
import '../../widgets/button.dart';

class PhoneVerification extends StatefulWidget {
  static const routeName = '/phone';

  const PhoneVerification({super.key});

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final mobileNo = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    mobileNo.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar('Register Phone'),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Hello", style: Theme.of(context).textTheme.titleLarge),
            const Text(
              "Enter your phone number for OTP Verification",
            ),
            Container(
              padding: EdgeInsets.zero,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 64,
                    child: Text(
                      "+91",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                    child: Text(
                      '|',
                      style: TextStyle(color: Colors.grey, fontSize: 32),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (value.length == 10) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      controller: mobileNo,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Phone Number",
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomFilledButton(
              onPressed: () async {
                if (mobileNo.text.length != 10) {
                  showSnackbarOnScreen(context, 'Enter Mobile Number');
                } else {
                  OTPScreen.code = List.generate(6, (index) => "-1");
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '+91${mobileNo.text}',
                    verificationCompleted: (PhoneAuthCredential credential) {
                      print("Here's the credential code ${credential.smsCode}");
                    },
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      Navigator.of(context).pushNamed(
                        OTPScreen.routeName,
                        arguments: {
                          "mobileNo": mobileNo.text,
                          "verificationId": verificationId,
                        },
                      );
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                }
              },
              child: const Text("Send Code"),
            ),
          ],
        )),
      ),
    );
  }
}
