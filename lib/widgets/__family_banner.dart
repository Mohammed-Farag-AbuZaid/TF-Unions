import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';

class FamilyBanner extends StatelessWidget {
  final int memberCount;

  const FamilyBanner({
    super.key,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: TFColors.navyAlt,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: TFColors.navyLine),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: TFColors.gold,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFFD6DCE8),
                      height: 1.45,
                    ),
                    children: [
                      const TextSpan(text: 'Community of '),
                      TextSpan(
                        text: '$memberCount',
                        style: const TextStyle(
                          color: TFColors.gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text: ' standout STEM & university scholars across Egypt.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
