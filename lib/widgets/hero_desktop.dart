import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/constants/social_items.dart';


class HeroDesktop extends StatelessWidget {
  const HeroDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return  Container(
                
                constraints: const BoxConstraints(minHeight:350),
                child:Column(
                  
                  children: [
                    SizedBox(height: 50,),

                    Image.asset('assets/DarkLogo.png', width:screenWidth * 0.3,),
                    
                    SizedBox(height: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('A None-Profit Organization \nbuilt Specially for standout students of Egypt.', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, height: 1.5),textAlign: TextAlign.center,),
                        ),
                        SizedBox(height: 30,),
                        SizedBox(
                          width: 300,
                          height: 50,
                          
                          child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: TFColors.whitePrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text('Join if you are', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),),)
                      ],
                    ),
                    SizedBox(height: 70,),
                    Row(
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
                    SizedBox(height: 20,),
                    
                  ],
                ),

              );
  }
}