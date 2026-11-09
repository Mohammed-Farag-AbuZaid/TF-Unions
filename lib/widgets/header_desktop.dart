import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/login.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/utils/tf_api.dart';
import 'package:tf_union/widgets/costum_dialog.dart';

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
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: TFColors.hair, width: 0.5),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() => _activeIndex = 0);
                        widget.onNavMenuTap(0);
                      },
                      child: const Text(
                        'TF Unions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: TFColors.ink,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(navItems.length, (i) {
                        final isActive = _activeIndex == i;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _activeIndex = i);
                            widget.onNavMenuTap(i);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            child: Text(
                              navItems[i],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? TFColors.ink
                                    : TFColors.muted,
                              ),
                            ),
                          ),
                        );
                      }),
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
                              color: TFColors.muted,
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
                            color: TFColors.tile,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Join TF Unions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: TFColors.ink,
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
                decoration: const BoxDecoration(
                  color: TFColors.tile,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: TFColors.accent,
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
                    color: TFColors.muted,
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
