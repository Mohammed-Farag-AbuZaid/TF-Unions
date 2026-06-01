import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/constants/social_items.dart';
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
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 20),
                  child: IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.arrow_back, color: TFColors.whitePrimary,)),
                ),
              ),
              for(int i = 0 ; i < navItems.length; i++)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(navIcons[i], color: TFColors.whitePrimary,),
                  title: Text(navItems[i], style: TextStyle(
                    color: TFColors.whitePrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
      
                  ),),
                  onTap: () {
                    onNavItemTap!(i);
                  },
                ),
              const SizedBox(height: 30,),
              for(int i = 0 ; i < log.length; i++)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(logIcons[i], color: TFColors.whitePrimary,),
                  title: Text(log[i], style: TextStyle(
                    color: TFColors.whiteSecondary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),),
                  onTap:(){
                    if (i == 0) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    } else if (i == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                    } 
                  },
                ),
      
                const SizedBox(height: 150,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < socialItems.length; i++)         
                       IconButton(onPressed: (){
                          if (i == 0) {
                            js.context.callMethod('open', ['https://www.youtube.com/']);
                          } else if (i == 1) {
                             js.context.callMethod('open', ['https://www.facebook.com/']);
                          } else if (i == 2) {
                            js.context.callMethod('open', ['https://chat.whatsapp.com/DSiidKAP0TP84vXA9Pand7']);
                          } else if (i == 3) {
                            js.context.callMethod('open', ['https://www.instagram.com/']);
                          }
                       }, icon: SizedBox(width: 30, height: 30, child: socialItems[i]), ),
                       
                                    
                  ],
                )
      
      
            ],
          ),
        ),
    );
  }
}