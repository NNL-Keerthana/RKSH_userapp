import 'dart:convert';

import 'package:flutter/material.dart';

import '../base_client.dart';
import '../constants.dart';
import 'home/home.dart';
import 'login/emergency_contacts.dart';
import 'login/phone.dart';
import 'login/signup_screen.dart';
import 'login/welcome.dart';
import 'package:http/http.dart' as http;

Future<int?> getStartScreen() async {
  final url = Uri.parse('${Constants.baseUrl}/user-signup-status');
  int signUpStatus = -1;

  final auth = BaseClient().auth;
  String? authToken = await BaseClient().getAuthToken();
  print(auth.currentUser);
  // BaseClient().printAuthTokenForTest();
  if (auth.currentUser == null) {
    print(1);
    return 1;
  } else if (auth.currentUser!.phoneNumber == null ||
      auth.currentUser!.phoneNumber == "") {
    print(2);
    return 2;
  } else {
    // print(authToken);
    var response = await http.post(
      url,
      headers: {'Authorization': authToken!},
    ).then((value) {
      print("Response  kadks body");
      return value;
    });
    print(response.body);
    var data = json.decode(response.body);
    signUpStatus = int.parse(data['status']);
    print(3 + signUpStatus);
    return 3 + signUpStatus;
  }
}

class StartupScreen extends StatefulWidget {
  static const routeName = '/startup';
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  late Future<int?> _getStartScreen;

  @override
  void initState() {
    super.initState();
    _getStartScreen = getStartScreen();
  }

  @override
  Widget build(BuildContext context) {
    if (BaseClient().auth.currentUser == null) {
      print('Sign in needed first TO DISPLAY AUTH TOKEN');
    } else {
      BaseClient().printAuthTokenForTest();
    }
    BaseClient().printFCMToken();
    return FutureBuilder(
        future: _getStartScreen,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            case ConnectionState.done:
            default:
              if (snapshot.hasError) {
                return Scaffold(
                  body: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                switch (snapshot.data) {
                  case 1:
                    {
                      return const WelcomeScreen();
                    }
                  case 2:
                    {
                      return const PhoneVerification();
                    }
                  case 3:
                    {
                      return const SignUpScreen();
                    }
                  case 4:
                    {
                      return const EmergencyContactsScreen();
                    }
                  case 5:
                    {
                      return const Home();
                    }
                  default:
                    return const Scaffold(body: Text('No Data'));
                }
              } else {
                return const Scaffold(body: Text('No Data'));
              }
          }
        });
  }
}
