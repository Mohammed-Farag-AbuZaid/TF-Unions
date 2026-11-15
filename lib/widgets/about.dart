import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/pages/docs_page.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 820;
    return Container(
      width: double.infinity,
      color: TFColors.canvas,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 2,
                  decoration: BoxDecoration(
                    color: TFColors.gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'About TF Unions',
                  style: TextStyle(
                    fontFamily: 'Bricolage Grotesque',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: TFColors.ink,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Our mission, founding vision, and guiding principles.',
                  style: TextStyle(fontSize: 15.5, color: TFColors.muted),
                ),
                const SizedBox(height: 28),
                if (wide)
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _AboutCard(
                          code: '01 · Mission',
                          content:
                              'Our mission is to provide students with the knowledge they need — even before they realize the questions they should be asking.',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _AboutCard(
                          code: '02 · Vision',
                          content:
                              'Our vision is to become the largest and most influential community for ambitious students in Egypt, building services that empower them to achieve their goals.',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _AboutCard(
                          code: '03 · Values',
                          content:
                              'Our values center around building a supportive family for all students. We believe that "زكاة العلم نشره" — sharing knowledge is a responsibility.',
                        ),
                      ),
                    ],
                  )
                else
                  const Column(
                    children: [
                      _AboutCard(
                        code: '01 · Mission',
                        content:
                            'Our mission is to provide students with the knowledge they need — even before they realize the questions they should be asking.',
                      ),
                      SizedBox(height: 12),
                      _AboutCard(
                        code: '02 · Vision',
                        content:
                            'Our vision is to become the largest and most influential community for ambitious students in Egypt, building services that empower them to achieve their goals.',
                      ),
                      SizedBox(height: 12),
                      _AboutCard(
                        code: '03 · Values',
                        content:
                            'Our values center around building a supportive family for all students. We believe that "زكاة العلم نشره" — sharing knowledge is a responsibility.',
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: TFColors.muted,
                      fontSize: 14,
                      height: 1.6,
                    ),
                    children: [
                      const TextSpan(text: 'For governance charters and full reference, open '),
                      TextSpan(
                        text: 'Foundation Docs ›',
                        style: const TextStyle(
                          color: TFColors.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
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
  final String code;
  final String content;
  const _AboutCard({
    required this.code,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: TFColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TFColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A161A22),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: TFColors.tealSoft,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: TFColors.gold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.6,
              color: TFColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
