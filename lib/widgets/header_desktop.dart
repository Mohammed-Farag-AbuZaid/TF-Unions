import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/login.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/widgets/costum_dialog.dart';
import 'package:tf_union/widgets/logo.dart';
import 'package:google_fonts/google_fonts.dart';

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
          margin: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          height: 64,
          decoration: BoxDecoration(
            color: TFColors.bglight1,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(20), width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // ── Logo ──────────────────────────────────────────────
                Logo(onTap: () {
                  setState(() => _activeIndex = 0);
                  widget.onNavMenuTap(0);
                }),

                const Spacer(),

                // ── Nav items ─────────────────────────────────────────
                Row(
                  children: List.generate(navItems.length, (i) {
                    final isActive = _activeIndex == i;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _activeIndex = i);
                        widget.onNavMenuTap(i);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white.withAlpha(25)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          navItems[i],
                          style: GoogleFonts.exo2(
                            fontSize: 14,
                            fontWeight: isActive
                                ? FontWeight.w500
                                : FontWeight.w400,
                            color: isActive
                                ? Colors.white
                                : Colors.white.withAlpha(100),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const Spacer(),

                // ── Auth / Avatar ──────────────────────────────────────
                if (user == null) ...[
                  _LoginButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ),
                  ),
                  const SizedBox(width: 4),
                  _RegisterButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    ),
                  ),
                ] else
                  _AvatarButton(uid: user.uid),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Login ──────────────────────────────────────────────────────────────────────
class _LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LoginButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          'Login',
          style: GoogleFonts.exo2(
            fontSize: 13,
            color: Colors.white.withAlpha(160),
          ),
        ),
      ),
    );
  }
}

// ── Register ───────────────────────────────────────────────────────────────────
class _RegisterButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RegisterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: TFColors.yellowPrimary,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          'Register',
          style: GoogleFonts.exo2(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// ── Avatar ─────────────────────────────────────────────────────────────────────
class _AvatarButton extends StatelessWidget {
  final String uid;
  const _AvatarButton({required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.exists == true
            ? snapshot.data!.data() as Map<String, dynamic>
            : <String, dynamic>{};

        final firstName = (data['firstName'] as String? ?? '').trim();
        final initial = firstName.isNotEmpty
            ? firstName[0].toUpperCase()
            : (currentUser.value?.email ?? 'U')[0].toUpperCase();
        final profilePic = data['profilePicture'] as String? ?? '';
        final username = data['username'] as String? ?? '';

        return GestureDetector(
          onTap: () => showProfileDialog(context: context),
          child: Row(
            children: [
              // ── Ring + avatar ────────────────────────────────────
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: TFColors.yellowPrimary.withAlpha(180),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: profilePic.isNotEmpty
                      ? Image.network(
                          profilePic,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _initialCircle(initial),
                        )
                      : _initialCircle(initial),
                ),
              ),

              // ── Username ─────────────────────────────────────────
              if (username.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  '@$username',
                  style: GoogleFonts.exo2(
                    fontSize: 13,
                    color: Colors.white.withAlpha(150),
                  ),
                ),
              ],

              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: Colors.white.withAlpha(80),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _initialCircle(String initial) {
    return Container(
      color: TFColors.bglight2,
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: TFColors.yellowPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}