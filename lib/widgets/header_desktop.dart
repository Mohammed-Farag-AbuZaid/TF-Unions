import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/login.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/utils/tf_api.dart';
import 'package:tf_union/widgets/costum_dialog.dart';
import 'package:tf_union/widgets/tf_logo_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderDesktop extends StatefulWidget {
  const HeaderDesktop({super.key, required this.onNavMenuTap});
  final Function(int) onNavMenuTap;

  @override
  State<HeaderDesktop> createState() => _HeaderDesktopState();
}

class _HeaderDesktopState extends State<HeaderDesktop> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentUser,
      builder: (context, user, _) {
        return Container(
          height: 64,
          decoration: const BoxDecoration(
            color: TFColors.navy,
            border: Border(
              bottom: BorderSide(color: TFColors.navyLine, width: 1),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() => _activeIndex = 0);
                        widget.onNavMenuTap(0);
                      },
                      child: const Row(
                        children: [
                          TfLogoMark(size: 28),
                          SizedBox(width: 10),
                          Text(
                            'TF Unions',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        ...List.generate(navItems.length, (i) {
                          final isActive = _activeIndex == i;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _activeIndex = i);
                              widget.onNavMenuTap(i);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: isActive
                                  ? BoxDecoration(
                                      color: TFColors.navyAlt,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: TFColors.navyLine,
                                      ),
                                    )
                                  : null,
                              child: Text(
                                navItems[i],
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: isActive
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isActive
                                      ? Colors.white
                                      : const Color(0xFFD6DCE8),
                                ),
                              ),
                            ),
                          );
                        }),
                        GestureDetector(
                          onTap: () => launchUrl(
                            Uri.parse('https://www.tfunions.com/team/'),
                            mode: LaunchMode.externalApplication,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            child: Text(
                              'Team',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFD6DCE8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (user == null) ...[
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFD6DCE8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: TFColors.accent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0xFF2853B8)),
                          ),
                          child: const Text(
                            'Join TF Unions',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ] else
                      _AvatarButton(uid: user.uid),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AvatarButton extends StatelessWidget {
  final String uid;
  const _AvatarButton({required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: TfApiService.fetchDoc('users', uid),
      builder: (context, snapshot) {
        final data = snapshot.data ?? <String, dynamic>{};
        final firstName = (data['firstName'] as String? ?? '').trim();
        final initial = firstName.isNotEmpty
            ? firstName[0].toUpperCase()
            : (currentUser.value?.email ?? 'U')[0].toUpperCase();
        final username = data['username'] as String? ?? firstName;

        return GestureDetector(
          onTap: () => showProfileDialog(context: context),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TFColors.navyAlt,
                  shape: BoxShape.circle,
                  border: Border.all(color: TFColors.gold, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (username.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
