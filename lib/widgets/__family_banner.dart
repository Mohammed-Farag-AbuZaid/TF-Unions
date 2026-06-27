import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tf_union/constants/tfcolors.dart';

class FamilyBanner extends StatelessWidget {
  final int memberCount;

  const FamilyBanner({
    super.key,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TFColors.yellowPrimary.withValues(alpha: 0.14),
            TFColors.yellowPrimary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: TFColors.bglight1.withValues(alpha: 0.25),
          width: 0.7,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: isSmall ? 20 : 22,
            color: TFColors.bglight1,
          ),
          const SizedBox(width: 14),

          /// Allows the text to wrap on small screens
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.exo2(
                  fontSize: isSmall ? 14 : 16,
                  color: TFColors.whitePrimary,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(
                    text: 'We are proud to be a community of ',
                  ),
                  TextSpan(
                    text: '$memberCount',
                    style: const TextStyle(
                      color: TFColors.yellowPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text: ' of Egypt’s brightest minds',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}