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
    width: 280,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: TFColors.tile,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imagePath.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                color: Colors.white,
                child: const Icon(
                  Icons.code_rounded,
                  color: TFColors.muted,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: TFColors.ink,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(
            color: TFColors.muted,
            fontSize: 14,
            height: 1.45,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 18),
        InkWell(
          onTap: !published
              ? null
              : () async {
                  await _launchURL(projectUrl);
                },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                !published ? 'Opening soon' : 'Explore',
                style: TextStyle(
                  color: !published ? TFColors.muted : TFColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              if (published) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right,
                  color: TFColors.accent,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
