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
    width: 288,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: TFColors.surface,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: TFColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D0A1931),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imagePath.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: TFColors.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Image.network(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: TFColors.inset,
                  child: const Center(
                    child: Icon(
                      Icons.code_rounded,
                      color: TFColors.navy,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: TFColors.inset,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            published ? 'Active Service' : 'Scheduled',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: published ? TFColors.success : TFColors.muted,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w700,
            color: TFColors.navy,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(
            color: TFColors.muted,
            fontSize: 13.5,
            height: 1.5,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: !published
              ? null
              : () async {
                  await _launchURL(projectUrl);
                },
          borderRadius: BorderRadius.circular(5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                !published ? 'Opening soon' : 'Explore project',
                style: TextStyle(
                  color: !published ? TFColors.muted : TFColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
              if (published) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: TFColors.accent,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
