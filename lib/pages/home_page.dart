import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          // the main section
          Container(
            height: 500,
            width: double.maxFinite,
            color: Colors.blue,

          )
        ],
      )
    );
  }
}