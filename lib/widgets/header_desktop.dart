import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/pages/login.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/widgets/costum_dialog.dart';
import 'package:tf_union/widgets/logo.dart';
import 'package:tf_union/constants/variables.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({super.key, required this.onNavMenuTap});
  final Function(int) onNavMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TFColors.bglight1, TFColors.bglight2],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Logo(onTap: () {}),
          const Spacer(),
          for (int i = 0; i < navItems.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextButton(
                onPressed: () {
                  onNavMenuTap(i);
                },
                child: Text(
                  navItems[i],
                  style: TextStyle(
                    color: TFColors.whitePrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          const Spacer(),
          if (loggedIn == false)
          for (int i = 0; i < log.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: TextButton(
                onPressed: () {
                  if (i == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  } else if (i == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  }
                },
                child: Text(
                  log[i],
                  style: TextStyle(
                    color: TFColors.whitePrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          if (loggedIn == true)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: MaterialButton(
              height: 50,
              minWidth: 50,
              color: TFColors.yellowPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500),
              ),
              onPressed: () {
                showProfileDialog(context: context);
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
