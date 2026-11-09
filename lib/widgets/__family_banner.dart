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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: TFColors.tile,
        borderRadius: BorderRadius.circular(16),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 15,
            color: TFColors.ink,
            height: 1.4,
          ),
          children: [
            const TextSpan(text: 'Community of '),
            TextSpan(
              text: '$memberCount',
              style: const TextStyle(
                color: TFColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(text: ' standout students across Egypt.'),
          ],
        ),
      ),
    );
  }
}
