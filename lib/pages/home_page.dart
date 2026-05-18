import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/widgets/header_desktop.dart';
import 'package:tf_union/widgets/header_mobile.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: TFColors.bglight1,
          drawer: constraints.maxWidth > MobileWidth?null: const DrawerMobile(),
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [ 
              // header
              if (constraints.maxWidth > MobileWidth)
                const HeaderDesktop(),
              if (constraints.maxWidth <= MobileWidth)
                HeaderMobile(
                onLogoTap: () {},
                onMenuTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),

              // Hero
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('A None Profit Organization, made Specially for the standout students in Egypt'),
                        ElevatedButton(onPressed: (){}, child: const Text('Join if you are'))
                      ],
                    ),
                    Image.asset('assets/DarkLogo.png',),
                  ],
                ),

              ),
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