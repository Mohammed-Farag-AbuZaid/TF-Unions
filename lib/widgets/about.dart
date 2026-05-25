import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/pages/register_page.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                
                width: double.maxFinite,
                color: TFColors.bglight2,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 90,),
                      Text('About Us', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: TFColors.whitePrimary), textAlign: TextAlign.center,),
                      SizedBox(height: 30,),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                          style: TextStyle(color: TFColors.whitePrimary, fontSize: 18, height: 1.5),
                          children: [
                            TextSpan(text: "TF Union is a student organization at the University of Toronto op their skills and connect with like-minded individuals. for more details you can read ourTF Union is a student organization at the University of Toronto that aims to foster a community of students interested in technology and entrepreneurship. We organize events, workshops, and hackathons to help students develop their skills and connect with like-minded individuals. for more details you can read our ", ),
                            TextSpan(
                              text: "Docs",
                              style: TextStyle(color: TFColors.yellowPrimary, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                              ..onTap = ()  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                                );
                                            },
                                        ),
                                           
                                      ],
                                      ),
                                      ),
                      ),
                      SizedBox(height: 30,),
                      Text('or', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, decoration: TextDecoration.underline, color: TFColors.whitePrimary) ,),
                      SizedBox(height: 30,),
                      ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: TFColors.bglight1, foregroundColor: TFColors.yellowPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text('Explore our services', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),),
                      SizedBox(height: 90,),
                    ],
                  ),
                ),
              );
  }
}