import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/constants/social_items.dart';
import 'package:tf_union/constants/variables.dart';
import 'dart:js' as js;

import 'package:tf_union/pages/login.dart';
import 'package:tf_union/pages/register_page.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({super.key, required this.onNavItemTap});
  final Function(int)? onNavItemTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: TFColors.bglight1,
        child: ValueListenableBuilder(
          valueListenable: currentUser,
          builder: (context, user, _) {
            return ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: TFColors.whitePrimary,
                      ),
                    ),
                  ),
                ),
                for (int i = 0; i < navItems.length; i++)
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    leading:
                        Icon(navIcons[i], color: TFColors.whitePrimary),
                    title: Text(
                      navItems[i],
                      style: const TextStyle(
                        color: TFColors.whitePrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () => onNavItemTap!(i),
                  ),
                const SizedBox(height: 30),
                if (user == null)
                  for (int i = 0; i < log.length; i++)
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      leading: Icon(logIcons[i],
                          color: TFColors.whitePrimary),
                      title: Text(
                        log[i],
                        style: const TextStyle(
                          color: TFColors.whiteSecondary,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => i == 0
                                ? const LoginPage()
                                : const RegisterPage(),
                          ),
                        );
                      },
                    ),
                const SizedBox(height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < socialItems.length; i++)
                      IconButton(
                        onPressed: () {
                          final urls = [
                            'https://www.youtube.com/',
                            'https://www.facebook.com/',
                            'https://chat.whatsapp.com/DSiidKAP0TP84vXA9Pand7',
                            'https://www.instagram.com/',
                          ];
                          js.context.callMethod('open', [urls[i]]);
                        },
                        icon: SizedBox(
                          width: 30,
                          height: 30,
                          child: socialItems[i],
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}