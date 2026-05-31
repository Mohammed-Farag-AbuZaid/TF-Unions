import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/widgets/about.dart';
import 'package:tf_union/widgets/header_desktop.dart';
import 'package:tf_union/widgets/header_mobile.dart';
import 'package:tf_union/widgets/hero_desktop.dart';
import 'package:tf_union/widgets/hero_mobile.dart';
import 'package:tf_union/widgets/drawer_mobile.dart';
import 'package:tf_union/pages/projects_page.dart';


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
          drawer: constraints.maxWidth > mobileWidth
              ? null
              : const DrawerMobile(),
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [
              // header
              if (constraints.maxWidth > mobileWidth) const HeaderDesktop(),
              if (constraints.maxWidth <= mobileWidth)
                HeaderMobile(
                  onLogoTap: () {},
                  onMenuTap: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                ),

              // Hero
              if (constraints.maxWidth > mobileWidth) const HeroDesktop(),
              if (constraints.maxWidth <= mobileWidth) HeroMobile(),

              // About
              About(),
              ProjectsPage(),
              // Footer
              Container(
                color: TFColors.bglight1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Copyright © 2026 TF Unions. All rights reserved.\nPowerd by SalamTech',
                    style: TextStyle(color: TFColors.whitePrimary, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
