import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/nav_items.dart';
import 'package:tf_union/constants/social_items.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  
                },
              ),
            SizedBox(height: 30,),
            for(int i = 0 ; i < log.length; i++)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(logIcons[i], color: TFColors.whitePrimary,),
                title: Text(log[i], style: TextStyle(
                  color: TFColors.whiteSecondary,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),),
                onTap:(){},
              ),

              SizedBox(height: 150,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < socialItems.length; i++)
                                SizedBox(
                                  width: 50,
                                  child: Expanded(
                                    child: IconButton(onPressed: (){}, icon: socialItems[i]),
                                  ),
                                )
                ],
              )


          ],
        ),
      );
  }
}