import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/project_card.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final db = FirebaseFirestore.instance;
  List<Widget> orgCards = [];
  List<Widget> projectCards = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final snapshot = await db.collection('orgs').get();
    orgCards.clear();
    projectCards.clear();
    final allProjectsSnapshot = await db.collection('allProjects').get();
    orgCards.clear();

    for (var doc in snapshot.docs) {
      orgCards.add(
        buildProjectCard(
          title: doc['name'],
          description: doc['description'],
          imagePath: doc['imgURL'],
          projectUrl: doc['projectURL'],
          published: doc['published'],
        ),
      );
    }

    for (var doc in allProjectsSnapshot.docs) {
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Services',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: TFColors.whitePrimary,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 40),
              height: 4,
              width: 200,
              decoration: BoxDecoration(
                color: TFColors.yellowPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'TF Sub-Orgs:',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: TFColors.whitePrimary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 25),

          Center(
            child: Wrap(
              spacing: 25,
              runSpacing: 25,
              alignment: WrapAlignment.center,
              children: orgCards,
            ),
          ),
          const SizedBox(height: 55),
          Text(
            'Projects :',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: TFColors.whitePrimary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Wrap(
              spacing: 25,
              runSpacing: 25,
              alignment: WrapAlignment.center,
              children: projectCards,
            ),
          ),
        ],
      ),
    );
  }
}
