import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';

class HeroMobile extends StatelessWidget {
  const HeroMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return  SingleChildScrollView(
      child: Container(
                  
                  constraints: const BoxConstraints(minHeight:570),
                  child:Column(
                    
                    children: [
                        Image.asset('assets/DarkLogo.png', width:screenWidth * 0.7,),
                      
                      SizedBox(height: 50,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text('A None-Profit Organization \nbuilt Specially for standout students of Egypt.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, height: 1.5),textAlign: TextAlign.center,),
                          ),
                          SizedBox(height: 60,),
                          SizedBox(
                            width: 250,
                            height: 50,
                            
                            child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: TFColors.yellowPrimary, foregroundColor: TFColors.whitePrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text('Join if you are', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),),)
                        ],
                      ),
                      SizedBox(height: 150,),
                      
                    ],
                  ),
      
                ),
    );
  }
}