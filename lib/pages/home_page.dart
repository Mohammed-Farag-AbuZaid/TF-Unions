import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/widgets/header_desktop.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TFColors.scaffoldBg,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [ 
          // header
          HeaderDesktop(),
          // About
          Container(
            height: 700,
            width: double.maxFinite,
            color: TFColors.bglight1,
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