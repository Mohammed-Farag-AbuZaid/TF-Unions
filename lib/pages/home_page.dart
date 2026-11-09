import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/docs_page.dart';
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
  final db = FirebaseFirestore.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final List<GlobalKey> navbarKeys = List.generate(4, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          drawer: constraints.maxWidth > mobileWidth
              ? null
              : DrawerMobile(
                  onNavItemTap: (int navIndex) {
                    scaffoldKey.currentState?.closeDrawer();
                    scrollToSection(navIndex);
                  },
                ),
          body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(key: navbarKeys.first),
                if (constraints.maxWidth > mobileWidth)
                  HeaderDesktop(
                    onNavMenuTap: (int navIndex) {
                      scrollToSection(navIndex);
                    },
                  ),
                if (constraints.maxWidth <= mobileWidth)
                  HeaderMobile(
                    onLogoTap: () {},
                    onMenuTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                if (constraints.maxWidth > mobileWidth) const HeroDesktop(),
                if (constraints.maxWidth <= mobileWidth) const HeroMobile(),
                About(key: navbarKeys[1]),
                ProjectsPage(key: navbarKeys[2]),
                Container(
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: TFColors.hair, width: 0.5),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                    child: Text(
                      'Copyright © 2026 TF Unions. All rights reserved.',
                      style: TextStyle(
                        color: TFColors.muted,
                        fontSize: 12,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void scrollToSection(int navIndex) {
    if (navIndex == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DocsPage()),
      );
      return;
    }
    final key = navbarKeys[navIndex];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
