import 'package:flutetr_demo/Body/TodoBody.dart';
import 'package:flutetr_demo/util/Text_Data.dart';
import 'package:flutetr_demo/util/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myDrawer(),
      appBar: AppBar(
        title: Text_Data(
            name: "H O M E P A G E", color: Colors.black, size: 20, maxLine: 1),
      ),
      body: AnimatedContainer(
        duration: Duration(microseconds: 200),
        child: Column(
          children: [Flexible(child: Todo_body())],
        ),
      ),
    );
  }
}
