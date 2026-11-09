import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/pages/docs_page.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About TF Unions',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: TFColors.ink,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Our mission, vision, and founding principles.',
                  style: TextStyle(fontSize: 16, color: TFColors.muted),
                ),
                const SizedBox(height: 32),
                const _AboutCard(
                  eyebrow: 'MISSION',
                  content:
                      'Our mission is to provide students with the knowledge they need — even before they realize the questions they should be asking.',
                ),
                const SizedBox(height: 16),
                const _AboutCard(
                  eyebrow: 'VISION',
                  content:
                      'Our vision is to become the largest and most influential community for ambitious students in Egypt, building services that empower them to achieve their goals.',
                ),
                const SizedBox(height: 16),
                const _AboutCard(
                  eyebrow: 'VALUES',
                  content:
                      'Our values center around building a supportive family for all students. We believe that "زكاة العلم نشره" — sharing knowledge is a responsibility.',
                ),
                const SizedBox(height: 32),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: TFColors.muted,
                      fontSize: 14,
                      height: 1.6,
                    ),
                    children: [
                      const TextSpan(text: 'For more details, check our '),
                      TextSpan(
                        text: 'Docs',
                        style: const TextStyle(
                          color: TFColors.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DocsPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String eyebrow;
  final String content;
  const _AboutCard({
    required this.eyebrow,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: TFColors.tile,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: TFColors.accent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: TFColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
