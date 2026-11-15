import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';

/// Geometric Fjord Slate & Botanical Teal Monogram mark matching all TF Unions portals.
class TfLogoMark extends StatelessWidget {
  final double size;
  const TfLogoMark({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: TFColors.navy,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Center(
            child: Text(
              'TF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                height: 1.0,
              ),
            ),
          ),
          Positioned(
            top: -1,
            right: -1,
            child: Container(
              width: size * 0.24,
              height: size * 0.24,
              decoration: BoxDecoration(
                color: TFColors.gold,
                shape: BoxShape.circle,
                border: Border.all(color: TFColors.surface, width: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
