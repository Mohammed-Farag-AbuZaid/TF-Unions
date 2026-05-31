/*
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Services',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: TFColors.whitePrimary,
              letterSpacing: 1.5,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 40),
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: TFColors.yellowPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Organization',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: TFColors.whitePrimary,
            ),
          ),

          // Organization cards
          Container(
            clipBehavior: Clip.antiAlias,
            height: 280,
            width: 260,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E24),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: Column(children: [Image.asset("assets/projects/stem.png")]),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Services',
            style: TextStyle(
              fontSize: 42, 
              fontWeight: FontWeight.bold,
              color: TFColors.whitePrimary,
              letterSpacing: 1.5,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 40),
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: TFColors.yellowPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Organization',
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold, 
              color: TFColors.whitePrimary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 25),
          Wrap(
            spacing: 25,
            runSpacing: 25,
            children: [
              _buildProjectCard(
                title: 'Stem union',
                description: " هنا نهدف الى مساعدة طلاب مدارس STEM  ", 
                imagePath: 'assets/projects/stem.png', 
                onBtnTap: () => _launchURL('https://google.com'), 
              ),
              _buildProjectCard(
                title: 'Universal union',
                description: " منظمة تهدف الى مساعدة الطلاب الجامعيين", 
                imagePath: 'assets/projects/', 
                onBtnTap: () => _launchURL('https://google.com'),
              ),
            ],
          ),
          const SizedBox(height: 55),
          Text(
            'Projects',
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold, 
              color: TFColors.whitePrimary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 25),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildProjectCard(
                title: 'shop',
                description: " محمد فرج هيكتب الوصف ", 
                imagePath: 'assets/projects/shop.png',
                onBtnTap: () => _launchURL('https://google.com'),
              ),
              _buildProjectCard(
                title: 'UNI Cap',
                description: "محمد فرج هيضيف ده", 
                imagePath: 'assets/projects/cap.png', 
                onBtnTap: () => _launchURL('https://google.com'), 
              ),
              _buildProjectCard(
                title: 'UV Journal',
                description: " محمد فرج هيكتب الوصف ده ", 
                imagePath: 'assets/projects/journal.png',
                onBtnTap: () => _launchURL('https://google.com'), 
              ),
              _buildProjectCard(
                title: 'English',
                description: "اكتب يا محمد هنا كمان الوصف", 
                imagePath: 'assets/projects/apc.png', 
                onBtnTap: () => _launchURL('https://google.com'), 
              ),
              _buildProjectCard(
                title: 'Guide',
                description: "اخر وصف بقا معلش هنتعبك", 
                imagePath: 'assets/projects/guide.png',
                onBtnTap: () => _launchURL('https://google.com'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard({
    required String title, 
    required String description, 
    required String imagePath,
    required VoidCallback onBtnTap,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 130,
                color: Colors.black26,
                child: const Icon(Icons.code_rounded, color: Colors.blueGrey, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onBtnTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: TFColors.yellowPrimary,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: const Text(
              'صفحة المشروع',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
