import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/pages/docs_page.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(minHeight: size.height),
      width: size.width,
      color: TFColors.bglight1,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Header ──────────────────────────────────────────────────
                Text(
                  'About Us',
                  style: GoogleFonts.exo2(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: TFColors.whitePrimary,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 3,
                  width: 60,
                  decoration: BoxDecoration(
                    color: TFColors.yellowPrimary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 56),

                // ── Mission ──────────────────────────────────────────────────
                _AboutCard(
                  eyebrow: 'MISSION',
                  content:
                      'Our mission is to provide students with the knowledge they need — even before they realize the questions they should be asking.',
                ),

                const SizedBox(height: 20),

                // ── Vision ───────────────────────────────────────────────────
                _AboutCard(
                  eyebrow: 'VISION',
                  content:
                      'Our vision is to become the largest and most influential community for ambitious students in Egypt, building services that empower them to achieve their goals.',
                ),

                const SizedBox(height: 20),

                // ── Values ───────────────────────────────────────────────────
                _AboutCard(
                  eyebrow: 'VALUES',
                  content:
                      'Our values center around building a supportive family for all students. We believe that "زكاة العلم نشره" — sharing knowledge is a responsibility.',
                ),

                const SizedBox(height: 48),

                // ── Docs link ────────────────────────────────────────────────
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.exo2(
                      color: TFColors.whiteSecondary.withValues(alpha: 0.7),
                      fontSize: 14,
                      height: 1.6,
                    ),
                    children: [
                      const TextSpan(text: 'For more details, check our '),
                      TextSpan(
                        text: 'Docs',
                        style: GoogleFonts.exo2(
                          color: TFColors.yellowPrimary,
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

// ── About card ────────────────────────────────────────────────────────────────
class _AboutCard extends StatelessWidget {
  final String eyebrow;
  final String content;
  const _AboutCard({
    required this.eyebrow,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          // Background + uniform hairline border
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: TFColors.whitePrimary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TFColors.whiteSecondary.withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
          ),
          // Yellow left accent bar
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              color: TFColors.yellowPrimary,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: GoogleFonts.exo2(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                    color: TFColors.yellowPrimary.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  style: GoogleFonts.exo2(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.7,
                    color: TFColors.whitePrimary.withValues(alpha: 0.88),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}