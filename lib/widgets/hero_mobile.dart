import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/register_page.dart';

import 'package:tf_union/widgets/project_card.dart';

class HeroMobile extends StatefulWidget {
  const HeroMobile({super.key});

  @override
  State<HeroMobile> createState() => _HeroMobileState();
}

class _HeroMobileState extends State<HeroMobile> {
  final db = FirebaseFirestore.instance;
  List<Widget> projectCards = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final snapshot = await db.collection('inProgressProjects').get();
    projectCards.clear();

    for (var doc in snapshot.docs) {
      projectCards.add(
        buildProjectCard(
          title: doc['name'],
          description: doc['description'],
          imagePath: doc['imgURL'],
          projectUrl: doc['projectURL'],
          published: doc['published'],
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Image.asset(
                'assets/BlackLogo.png',
                width: screenWidth * 0.7,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 50, right: 50),
              child: Text(
                loggedIn
                    ? 'we are cooking something special for you, stay tuned!'
                    : 'A None-Profit Organization \nbuilt Specially for standout students of Egypt.',
                style: GoogleFonts.robotoSlab(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (!loggedIn)
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TFColors.yellowPrimary,
                    foregroundColor: TFColors.whitePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Join us',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (!loggedIn) SizedBox(height: 150),
            if (loggedIn)
              Wrap(
                spacing: 25,
                runSpacing: 25,
                alignment: WrapAlignment.center,
                children: projectCards,
              ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
