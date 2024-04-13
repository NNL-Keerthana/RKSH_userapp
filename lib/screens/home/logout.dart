import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:userapp/screens/login/welcome.dart';

import '../../widgets/button.dart';

void logout(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Theme(
      data: Theme.of(ctx)
          .copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
      child: AlertDialog(
        // backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Logout",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.indigo[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CustomOutlinedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(ctx).pushNamedAndRemoveUntil(
                WelcomeScreen.routeName,
                (route) => false,
              );
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(
                const BorderSide(color: Colors.red),
              ),
            ),
            child: const Text("Yes"),
          ),
          CustomFilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("No")),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    ),
  );
}
