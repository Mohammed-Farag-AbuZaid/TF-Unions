import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/utils/tf_api.dart';
import 'package:tf_union/widgets/costum_dialog.dart';

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
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: TFColors.hair, width: 0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onMenuTap,
                  child: const SizedBox(
                    width: 38,
                    height: 38,
                    child: Icon(
                      Icons.menu_rounded,
                      color: TFColors.ink,
                      size: 22,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onLogoTap,
                  child: const Text(
                    'TF Unions',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: TFColors.ink,
                    ),
                  ),
                ),
                const Spacer(),
                if (user != null)
                  FutureBuilder<Map<String, dynamic>?>(
                    future: TfApiService.fetchDoc('users', user.uid),
                    builder: (context, snapshot) {
                      final data = snapshot.data ?? <String, dynamic>{};
                      final firstName =
                          (data['firstName'] as String? ?? '').trim();
                      final initial = firstName.isNotEmpty
                          ? firstName[0].toUpperCase()
                          : (currentUser.value?.email ?? 'U')[0].toUpperCase();
                      return GestureDetector(
                        onTap: () => showProfileDialog(context: context),
                        child: Container(
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
}
