import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:url_launcher/url_launcher.dart';
Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

Widget buildProjectCard({
    required String title,
    required String description,
    required String imagePath,
    required String projectUrl,
    required bool published,
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
            child: Image.network(
              imagePath,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 130,
                color: Colors.black26,
                child: const Icon(
                  Icons.code_rounded,
                  color: Colors.blueGrey,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          
          ElevatedButton(
            onPressed: !published ? null : () async { await _launchURL(projectUrl); },
            style: ElevatedButton.styleFrom(
              backgroundColor: TFColors.yellowPrimary,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: Text(
              !published ? 'Coming Soon' :
              'Take a look',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),

        ],
      ),
    );
  }

