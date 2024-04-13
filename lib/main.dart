import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:userapp/models/notifications.dart';
import 'package:userapp/screens/login/invite_ice.dart';
import 'package:userapp/screens/login/signup_screen.dart';
import './firebase_options.dart';
import './screens/login/additional_details.dart';
import './screens/login/emergency_contacts.dart';
import './screens/login/otp.dart';
import './screens/login/phone.dart';
import './screens/login/welcome.dart';
import 'screens/home/home.dart';
import 'screens/startup.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseNotifications().initNotifications();
  FirebaseMessaging.onBackgroundMessage(
    (message) => FirebaseNotifications().handleMessage(message),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigoAccent,
        useMaterial3: true,
        fontFamily: "Montserrat",
      ),
      // showPerformanceOverlay: true,

      home: const StartupScreen(),

      // home: const EmergencyContactsScreen(),
      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        PhoneVerification.routeName: (context) => const PhoneVerification(),
        OTPScreen.routeName: (context) => OTPScreen(),
        StartupScreen.routeName: (context) => const StartupScreen(),
        EmergencyContactsScreen.routeName: (context) =>
            const EmergencyContactsScreen(),
        InviteContacts.routeName: (context) => const InviteContacts(),
        Home.routeName: (context) => const Home(),
        AdditionalDetailsScreen.routeName: (context) =>
            const AdditionalDetailsScreen(),
      },
    );
  }
}
