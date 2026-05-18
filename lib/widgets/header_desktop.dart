import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/widgets/logo.dart';
import 'package:tf_union/widgets/logo_mobile.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [TFColors.bglight1, TFColors.bglight2]),
              borderRadius: BorderRadius.circular(100),

            ),
            child: Row(
              children: [
                Logo(
                  onTap: (){},
                ),
                const Spacer(),
                for(int i = 0; i < navItems.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: TextButton(onPressed: (){}, child: Text(navItems[i], style: TextStyle(
                      color: TFColors.whitePrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,

                    ),
                    ),
                    ),
                  ),
                const Spacer(),
                for(int i = 0; i < log.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: TextButton(onPressed: (){}, child: Text(log[i], style: TextStyle(
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