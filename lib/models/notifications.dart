import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  final _firebasemessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebasemessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((event) => handleMessage(event));
  }

  @pragma('vm:entry-point')
  Future<void> handleMessage(RemoteMessage message) async {
    print('Got a message whilst in somewhere you know!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }
}
