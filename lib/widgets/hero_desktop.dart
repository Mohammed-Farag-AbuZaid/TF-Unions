import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/social_items.dart';


class HeroDesktop extends StatelessWidget {
  const HeroDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return  Container(
                
                height: MediaQuery.of(context).size.height * 0.93,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Image.asset('assets/BlackLogo.png', width:screenWidth * 0.3,),
                    ),
                        Text('A None-Profit Organization \nbuilt Specially for standout students of Egypt.', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, height: 1.5, color: TFColors.whitePrimary),textAlign: TextAlign.center,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            
                            child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: TFColors.whitePrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text('Join if you are', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),),),
                        ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        children: [
                        
                           Spacer(),
                           Spacer(),
                          SizedBox(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              
                              children: [
                                for (int i = 0; i < socialItems.length; i++)
                                  Expanded(
                                    child: IconButton(onPressed: (){}, icon: socialItems[i]),
                                  )
                              ],
                            ),
                          ),
                            
                              
                        ],
                      ),
                    ),


                  ],
                
                ),

              );
  }
}