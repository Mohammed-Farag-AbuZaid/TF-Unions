import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/docs_page.dart';
import 'package:tf_union/pages/projects_page.dart';
import 'package:tf_union/widgets/about.dart';
import 'package:tf_union/widgets/drawer_mobile.dart';
import 'package:tf_union/widgets/hero_desktop.dart';
import 'package:tf_union/widgets/hero_mobile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: TFColors.canvas,
          drawer: constraints.maxWidth > mobileWidth
              ? null
              : DrawerMobile(
                  onNavItemTap: (int navIndex) {
                    scaffoldKey.currentState?.closeDrawer();
                    _openNavPage(navIndex);
                  },
                ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (constraints.maxWidth > mobileWidth)
                  const HeroDesktop()
                else
                  const HeroMobile(),
                Container(
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    color: TFColors.surface,
                    border: Border(
                      top: BorderSide(color: TFColors.border, width: 1),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                    child: Text(
                      'TF Unions Foundation · Copyright © 2026 TF Unions. All rights reserved.',
                      style: TextStyle(
                        color: TFColors.muted,
                        fontSize: 13,
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

  void _openNavPage(int navIndex) {
    if (navIndex == 0) return;
    Widget page;
    switch (navIndex) {
      case 1:
        page = const AboutScreen();
        break;
      case 2:
        page = const ProjectsScreen();
        break;
      case 3:
      default:
        page = const DocsPage();
        break;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _InlineBackHeader extends StatelessWidget {
  const _InlineBackHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: TFColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TFColors.border),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 16, color: TFColors.ink),
                    SizedBox(width: 6),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: TFColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: TFColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InlineBackHeader(),
              About(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectsScreen extends StatelessWidget {
  final ProjectFilter initialFilter;

  const ProjectsScreen({
    super.key,
    this.initialFilter = ProjectFilter.all,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TFColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _InlineBackHeader(),
              ProjectsPage(initialFilter: initialFilter),
            ],
          ),
        ),
      ),
    );
  }
}
