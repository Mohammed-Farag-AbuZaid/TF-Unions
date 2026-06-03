import 'package:flutter/material.dart';
import 'package:tf_union/constants/faq.dart';
import 'package:google_fonts/google_fonts.dart';

class DocsPage extends StatelessWidget {
  const DocsPage({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Center(
          child: SizedBox(
            width: 250,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 30),
              child: Image.asset('assets/BlackLogo.png'),
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: .3),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111111),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFF0A2D91)),
                          ),
                          child: const Text(
                            "TF Union is an educational platform that connects students with tools, resources, projects, and learning communities to help them grow faster and learn in a more structured way.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              height: 1.9,
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        ...faqs.map(
                          (faq) => Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            constraints: const BoxConstraints(maxWidth: 900),
                            child: Card(
                              color: const Color(0xFF111111),
                              elevation: 12,
                              shadowColor: const Color(0xFF0A2D91),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Color(0xFF0A2D91),
                                ),
                              ),
                              child: Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  collapsedIconColor: const Color(0xFFFFB800),
                                  iconColor: const Color(0xFFFFB800),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0A2D91),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.help_outline,
                                      color: Color(0xFFFFB800),
                                    ),
                                  ),
                                  title: Text(
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    faq["q"]!,
                                    
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        15,
                                        8,
                                        15,
                                        8,
                                      ),
                                      child: Text(
                                        style: GoogleFonts.exo2(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.white,
                                    ),
                                        faq["a"]!,
                                        
                                        
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
