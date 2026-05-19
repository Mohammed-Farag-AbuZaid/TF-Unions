import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/drawer_mobile.dart';
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      child: Column(
        children: [
          const Text(
            'upcoming projects',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: TFColors.whitePrimary,
            ),
          )
        ],
      ),
    );
  }
}