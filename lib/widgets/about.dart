import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/pages/docs_page.dart';
import 'package:tf_union/widgets/fields.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: TFColors.bglight1,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 70.0),
              child: Text(
                'About Us',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: TFColors.whitePrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            buildTextArea(
              content:
                  'Our mission is to provide students with the knowledge they need — even before they realize the questions they should be asking.',
            ),
            buildTextArea(
              content:
                  'Our vision is to become the largest and most influential community for ambitious students in Egypt, building services that empower them to achieve their goals.',
            ),
            buildTextArea(
              content:
                  'Our values center around building a supportive family for all students. We believe that "زكاة العلم نشره" — sharing knowledge is a responsibility.',
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, top: 30.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: TFColors.whitePrimary,
                    fontSize: 18,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: "For more details, check our "),
                    TextSpan(
                      text: "Docs",
                      style: TextStyle(
                        color: TFColors.yellowPrimary,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DocsPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
