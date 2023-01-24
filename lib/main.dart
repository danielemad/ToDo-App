import 'package:flutter/material.dart';
import 'package:todo_app/db/db_helper.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/views/screens/home_screen.dart';
import "package:get/get.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();
  await DBHelper.initDB();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
