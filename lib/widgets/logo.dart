import 'package:flutter/cupertino.dart';
import 'package:tf_union/constants/tfcolors.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onTap,
      child: const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          'TF-Unions',
          style: TextStyle(
            color: TFColors.yellowPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
