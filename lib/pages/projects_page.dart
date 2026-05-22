import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/drawer_mobile.dart';
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TFColors.bglight1,
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
          ),

          //projects cards
          Container(
            clipBehavior: Clip.antiAlias,
            height: 280,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: TFColors.yellowSecondary,
              border: Border.all(color: TFColors.yellowPrimary),
            ),
            child: Column(
              children: [
                Image.asset('assets/projects/stem.png', height: 150, width: 250, fit: BoxFit.cover,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}