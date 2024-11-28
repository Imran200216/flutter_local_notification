import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  /// initialize the flutter local notification plugin instance
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {}

  /// initialize the notification plugin
  static Future<void> init() async {
    /// define the android initialization
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    /// define the ios initialization
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    /// combine android and ios initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    /// initialize the plugin with the specific settings
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    /// request notification permission
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.requestNotificationsPermission();
  }

  /// request notification permission for android
  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_Id",
        "channel_Name",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  /// show a schedule notification
  static Future<void> scheduleNotification(
      String title, String body, DateTime scheduleDate) async {
    /// define notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_Id",
        "channel_Name",
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(
        scheduleDate,
        tz.local,
      ),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
