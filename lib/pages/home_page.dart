import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tf_union/constants/tfcolors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tfcolors.scaffoldBg,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          // Home
          Container(
            height: 1000,
            width: double.maxFinite,
          

          ),
          // About
          Container(
            height: 1000,
            width: double.maxFinite,
            color: Colors.blue,
          ),
          // Projects
          Container(
            height: 1000,
            width: double.maxFinite,


          ),


        ],
      )
    );
  }
}