import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/widgets/costum_dialog.dart';
import 'package:tf_union/widgets/logo.dart';

class HeaderMobile extends StatelessWidget {
  const HeaderMobile({super.key, this.onLogoTap, this.onMenuTap});
  final VoidCallback? onLogoTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentUser,
      builder: (context, user, _) {
        return Container(
          height: 64,
          margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          decoration: BoxDecoration(
            color: TFColors.bglight1,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(20), width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                // ── Menu ──────────────────────────────────────────────
                GestureDetector(
                  onTap: onMenuTap,
                  child: SizedBox(
                    width: 38,
                    height: 38,
                    child: Icon(
                      Icons.menu_rounded,
                      color: Colors.white.withAlpha(200),
                      size: 22,
                    ),
                  ),
                ),

                // ── Logo (centered) ───────────────────────────────────
                const Spacer(),
                Logo(onTap: onLogoTap),
                const Spacer(),

                // ── Avatar or placeholder ─────────────────────────────
                if (user != null)
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.exists == true
                          ? snapshot.data!.data() as Map<String, dynamic>
                          : <String, dynamic>{};

                      final firstName =
                          (data['firstName'] as String? ?? '').trim();
                      final initial = firstName.isNotEmpty
                          ? firstName[0].toUpperCase()
                          : (currentUser.value?.email ?? 'U')[0].toUpperCase();
                      final profilePic =
                          data['profilePicture'] as String? ?? '';

                      return GestureDetector(
                        onTap: () => showProfileDialog(context: context),
                        child: Container(
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
                                    errorBuilder: (_, _, _) =>
                                        _initialCircle(initial),
                                  )
                                : _initialCircle(initial),
                          ),
                        ),
                      );
                    },
                  )
                else
                  const SizedBox(width: 34),
              ],
            ),
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