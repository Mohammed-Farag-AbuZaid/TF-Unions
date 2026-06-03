import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/docs_page.dart';
import 'package:tf_union/pages/login.dart';
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
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.black,
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

                // Hero
                if (constraints.maxWidth > mobileWidth) const HeroDesktop(),
                if (constraints.maxWidth <= mobileWidth) HeroMobile(),

                // About
                About(key: navbarKeys[1]),
                ProjectsPage(key: navbarKeys[2]),
                // Footer
                Container(
                  width: screenWidth,
                  color: TFColors.bglight1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Copyright © 2026 TF Unions. All rights reserved.\nPowerd by SalamTech',
                      style: TextStyle(
                        color: TFColors.whitePrimary,
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
    }
    final key = navbarKeys[navIndex];
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
