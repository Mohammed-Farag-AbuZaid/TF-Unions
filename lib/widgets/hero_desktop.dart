import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/social_items.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/register_page.dart';
import 'dart:js' as js;

class HeroDesktop extends StatelessWidget {
  const HeroDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.93,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Image.asset(
              'assets/BlackLogo.png',
              width: screenWidth * 0.3,
            ),
          ),
          Text(
            loggedIn
                ? 'Take a look at our Latest services and projects :'
                : 'A None-Profit Organization \nbuilt Specially for standout students of Egypt.',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: TFColors.whitePrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: SizedBox(
              width: 300,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  loggedIn
                      ? js.context.callMethod('open', [
                          'https://www.example.com',
                        ])
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: TFColors.whitePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  loggedIn ? 'Explore A.P.C Now' : 'Join us',

                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
                          child: IconButton(
                            onPressed: () {
                              if (i == 0) {
                                js.context.callMethod('open', [
                                  'https://www.youtube.com/',
                                ]);
                              } else if (i == 1) {
                                js.context.callMethod('open', [
                                  'https://www.facebook.com/',
                                ]);
                              } else if (i == 2) {
                                js.context.callMethod('open', [
                                  'https://chat.whatsapp.com/DSiidKAP0TP84vXA9Pand7',
                                ]);
                              } else if (i == 3) {
                                js.context.callMethod('open', [
                                  'https://www.instagram.com/',
                                ]);
                              }
                            },
                            icon: socialItems[i],
                          ),
                        ),
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
