
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notification/features/home/presentation/ui/home_screen.dart';
import 'package:flutter_local_notification/features/home/repository/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  playSound: true,
  importance: Importance.high,
  "high_importance_channel",
  "High Importance Notifications",
  description: "This is the important notification",
);

/// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// /// initializing the firebase messaging
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("A bg message is showing up: ${message.messageId}");
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// loading env file
  await dotenv.load(fileName: "assets/.env");

  await NotificationService.init();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode, // Unique ID for the notification
          notification.title ?? 'No Title', // Provide default title if null
          notification.body ?? 'No Body', // Provide default body if null
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, // Channel ID
              channel.name, // Channel Name
              channelDescription: channel.description,
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
              icon: "@mipmap/ic_launcher",
            ),
          ),
        );
      }
    });

    /// firebase on message open app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessageOpenedApp event was published!");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(notification.title ?? 'No Title'),
              // Provide default title
              content:
                  Text(notification.body ?? 'No Body'), // Provide default body
            );
          },
        );
      }
    });
  }

  void showNotification() {
    setState(() {});

    flutterLocalNotificationsPlugin.show(
      0,
      "hi",
      "how your are doing",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id, // Channel ID
          channel.name, // Channel Name
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: "@mipmap/ic_launcher",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
