import 'package:flutter/material.dart';
import 'package:flutter_local_notification/features/home/repository/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                NotificationService.showInstantNotification(
                    "hi Dhanush", "How are you buddy");
              },
              child: Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Text(
                    "Notify",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                DateTime scheduleDate = DateTime.now().add(const Duration(
                  seconds: 4,
                ));
                NotificationService.scheduleNotification(

                    /// title , /// decription, /// tz
                    "hi dhanush",
                    "Schedule notificaiton",
                    scheduleDate);
              },
              child: Container(
                height: 40,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Text(
                    "Schedule notify",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
