import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';

/// Custom geometric TF Monogram mark matching the web & ecosystem identity.
class TfLogoMark extends StatelessWidget {
  final double size;
  const TfLogoMark({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: TFColors.accent,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Stack(
        children: [
          const Center(
            child: Text(
              'TF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.0,
              ),
            ),
          ),
          Positioned(
            top: size * 0.14,
            right: size * 0.14,
            child: Container(
              width: size * 0.14,
              height: size * 0.14,
              decoration: BoxDecoration(
                color: TFColors.gold,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
