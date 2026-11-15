import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/constants/social_items.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/login.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({super.key, required this.onNavItemTap});
  final Function(int)? onNavItemTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: TFColors.surface,
        child: ValueListenableBuilder(
          valueListenable: currentUser,
          builder: (context, user, _) {
            return ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 14),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: TFColors.ink,
                      ),
                    ),
                  ),
                ),
                for (int i = 0; i < navItems.length; i++)
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    leading: Icon(navIcons[i], color: TFColors.ink),
                    title: Text(
                      navItems[i],
                      style: const TextStyle(
                        color: TFColors.ink,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () => onNavItemTap?.call(i),
                  ),
                const Divider(color: TFColors.border, height: 24),
                if (user == null)
                  for (int i = 0; i < log.length; i++)
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      leading: Icon(logIcons[i], color: TFColors.accent),
                      title: Text(
                        log[i],
                        style: const TextStyle(
                          color: TFColors.ink,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => i == 0
                                ? const LoginPage()
                                : const RegisterPage(),
                          ),
                        );
                      },
                    )
                else ...[
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: const Icon(Icons.person_outline, color: TFColors.gold),
                    title: Text(
                      user.displayName ?? user.email ?? 'Signed in',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: TFColors.ink,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                    subtitle: user.email != null
                        ? Text(
                            user.email!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: TFColors.muted,
                              fontSize: 12,
                            ),
                          )
                        : null,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: const Icon(Icons.logout_rounded, color: Color(0xFFB91C1C)),
                    title: const Text(
                      'Sign out',
                      style: TextStyle(
                        color: Color(0xFFB91C1C),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
                const SizedBox(height: 36),
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
                          launchUrl(
                            Uri.parse(urls[i]),
                            mode: LaunchMode.externalApplication,
                          );
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