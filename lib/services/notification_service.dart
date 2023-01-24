import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService
{

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
  FlutterLocalNotificationsPlugin();

  NotificationService.init()
  {
    
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("appicon");

    const DarwinInitializationSettings darwinInitializationSettings = 
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings = 
    InitializationSettings(android:androidInitializationSettings , iOS:darwinInitializationSettings);

    tz.initializeTimeZones();
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (x) {
        print(x.payload);
      }
    );
  }

  NotificationService.showNotification({
      required int id,
      required String title ,
      required String body ,
      String? payload
    }) {


    _flutterLocalNotificationsPlugin.show(
      id,
      title, 
      body,
      _initNotificationDetails(),
      payload: payload
    );
  }

  NotificationDetails _initNotificationDetails() 
  => const NotificationDetails(
      android: AndroidNotificationDetails(
        "channel id",
        "channel name",
        importance: Importance.max,
        priority: Priority.high
      ), 
      iOS:DarwinNotificationDetails(),  
    );


  NotificationService.scheduleNotification({
    required int id,
    required String title ,
    required String body ,
    required DateTime reminderDate,
    String? payload
  }){

    _flutterLocalNotificationsPlugin.zonedSchedule(
      id, 
      title,
      body,
      tz.TZDateTime.from(reminderDate,tz.local), 
      _initNotificationDetails(), 
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true
    );
    

  }

  


}