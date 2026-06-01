import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';

class HeroMobile extends StatelessWidget {
  const HeroMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return  SingleChildScrollView(
      child: SizedBox(
                  
                  height: MediaQuery.of(context).size.height * 0.95,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Image.asset('assets/BlackLogo.png', width:screenWidth * 0.7,),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, left: 50, right: 50),
                        child: Text('A None-Profit Organization \nbuilt Specially for standout students of Egypt.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, height: 1.5),textAlign: TextAlign.center,),
                      ),
                      SizedBox(
                        width: 250,
                        height: 50,
                        
                        child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: TFColors.yellowPrimary, foregroundColor: TFColors.whitePrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text('Join if you are', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),),),
                      SizedBox(height: 150,),
                      
                    ],
                  ),
      
                ),
    );
  }
}