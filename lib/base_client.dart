import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseClient {
  final auth = FirebaseAuth.instance;

  final fcmToken = FirebaseMessaging.instance;

  Future<String?> getAuthToken() async {
    if (auth.currentUser == null) {
      return null;
    }
    final s = await auth.currentUser!.getIdToken();
    return s;
  }

  void printAuthTokenForTest() async {
    final user = FirebaseAuth.instance.currentUser!;
    String? firebaseIdToken = await user.getIdToken();
    while (firebaseIdToken!.isNotEmpty) {
      int startTokenLength =
          (firebaseIdToken.length >= 500 ? 500 : firebaseIdToken.length);
      print("TokenPart: " + firebaseIdToken.substring(0, startTokenLength));
      int lastTokenLength = firebaseIdToken.length;
      firebaseIdToken =
          firebaseIdToken.substring(startTokenLength, lastTokenLength);
    }
    // print(firebaseIdToken);
  }

  Future<String?> getFCMToken() async {
    var s = await fcmToken.getToken();
    return s;
  }

  void printFCMToken() async {
    var s = await fcmToken.getToken();
    print("FCM TOKEN: $s");
  }

  Future<void> launchBrowserWithUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
    }
  }
}
