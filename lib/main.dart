import 'package:flutetr_demo/Body/Add_Todo.dart';
import 'package:flutetr_demo/Getx/DatabaseHelper.dart';
import 'package:flutetr_demo/homePage/HomePage.dart';
import 'package:flutetr_demo/homePage/loginPage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter đã được khởi tạo
  await todoProvider.open();
  // await todoProvider.insertSampleUsers();
  // await todoProvider.addDataTodo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loginPage(),
    );
  }
}
