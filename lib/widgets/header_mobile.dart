import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
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
              gradient: LinearGradient(colors: [TFColors.bglight1, TFColors.bglight2]),
              borderRadius: BorderRadius.circular(20),

            ),
            child: Row(
              children: [
                
                
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(onPressed: onMenuTap, icon: Icon(Icons.menu, color: TFColors.whitePrimary,)),
                ),
                const Spacer(),
                Logo(
                  onTap: onLogoTap,
                ),
                const Spacer(),
                SizedBox(
                  width: 20, 
                )

                

              ],
            ),
          );
  } 
}