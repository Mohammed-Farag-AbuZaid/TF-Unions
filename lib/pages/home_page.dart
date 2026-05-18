import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/widgets/header_desktop.dart';
import 'package:tf_union/widgets/header_mobile.dart';
import 'package:tf_union/widgets/hero_desktop.dart';
import 'package:tf_union/widgets/hero_mobile.dart';
import 'package:tf_union/widgets/logo.dart';
import 'package:tf_union/widgets/drawer_mobile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: TFColors.bglight1,
          drawer: constraints.maxWidth > mobileWidth?null: const DrawerMobile(),
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [ 
              // header
              if (constraints.maxWidth > mobileWidth)
                const HeaderDesktop(),
              if (constraints.maxWidth <= mobileWidth)
                HeaderMobile(
                onLogoTap: () {},
                onMenuTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),

              // Hero
              if (constraints.maxWidth > mobileWidth)
                const HeroDesktop(),
              if (constraints.maxWidth <= mobileWidth)
                HeroMobile(),
              
              // About
              Container(
                height: 650,
                width: double.maxFinite,
                color: TFColors.scaffoldBg,
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
    );
  }
}