import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/widgets/logo.dart';

class HeaderMobile extends StatelessWidget {
  const HeaderMobile({super.key, this.onLogoTap, this.onMenuTap});
  final VoidCallback? onLogoTap;
  final VoidCallback? onMenuTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TFColors.bglight1, TFColors.bglight2],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: onMenuTap,
              icon: Icon(Icons.menu, color: TFColors.whitePrimary),
            ),
          ),
          const Spacer(),
          Logo(onTap: onLogoTap),
          const Spacer(),
          SizedBox(width: 20),
          if (loggedIn == true)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: MaterialButton(
              height: 40,
              minWidth: 40,
              color: TFColors.yellowPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text(
                'M',
                style: TextStyle(
                  color: TFColors.whitePrimary,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
