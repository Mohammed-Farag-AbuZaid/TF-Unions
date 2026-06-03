import 'package:flutter/material.dart';

void main() {
  runApp(const TFUnionDocsApp());
}

class TFUnionDocsApp extends StatelessWidget {
  const TFUnionDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TF Union Docs',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: const DocsPage(),
    );
  }
}

class DocsPage extends StatelessWidget {
  const DocsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "q": "What is TF Union?",
        "a": """
TF Union is an educational platform and community designed to help students and learners by providing organized tools, projects, and learning guides in one place.

Our goal is to reduce confusion and make access to educational resources easier, clearer, and more structured.
""",
      },
      {
        "q": "Why was TF Union created?",
        "a": """
TF Union was created to help students find everything they need for learning in one place instead of searching randomly across scattered resources.

We focus on organizing knowledge and presenting it in a simple and practical way.
""",
      },
      {
        "q": "Who is TF Union for?",
        "a": """
The platform is designed for:

• High school students  
• University students  
• Self-learners  
• Students interested in programming, science, and math  
• Anyone who wants to improve themselves  

If you are ambitious and love learning, this platform is for you.
""",
      },
      {
        "q": "What services does TF Union provide?",
        "a": """
We provide several educational services such as:

• Student projects  
• Learning guides for different fields  
• English learning tools  
• Structured educational content  
• Supportive learning communities  

More services are being developed and added over time.
""",
      },
      {
        "q": "Are all services available now?",
        "a": """
No, the project is still under development.

Some services are already available, while others are being built and will be released gradually.
""",
      },
      {
        "q": "What are educational projects?",
        "a": """
They are ideas and tools that help students build or understand projects, or use ready-made structured ideas that they can develop for learning purposes.
""",
      },
      {
        "q": "What are Guides?",
        "a": """
Guides are structured learning paths that help students understand a specific field step by step without confusion.

They include curated resources and clear learning roadmaps.
""",
      },
      {
        "q": "Is the platform free?",
        "a": """
Most services are currently free.

Our main goal is to provide real educational value without barriers for students.
""",
      },
      {
        "q": "What is TF Union’s vision?",
        "a": """
To become the leading platform for students and learners in the Arab world by providing organized educational tools, resources, and opportunities.
""",
      },
      {
        "q": "What makes TF Union different?",
        "a": """
We don’t provide random content.

We focus on organization, quality, and delivering the right resource to the right student at the right time.
""",
      },
      {
        "q": "What are the future plans?",
        "a": """
• Developing more educational tools  
• Expanding student communities  
• Supporting more academic fields  
• Improving user experience  
• Reaching more students in Egypt and the Arab world  

We are just getting started.
""",
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2D91),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: .3),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Image.asset(
                      'assets/BlackLogo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "TF UNION",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Educational Hub For Ambitious Students",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),

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

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "${faqs.length} Frequently Asked Questions",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
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
                          side: const BorderSide(color: Color(0xFF0A2D91)),
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
                              faq["q"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  28,
                                  8,
                                  28,
                                  28,
                                ),
                                child: Text(
                                  faq["a"]!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    height: 2.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    constraints: const BoxConstraints(maxWidth: 900),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFFFB800)),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.emoji_objects,
                          color: Color(0xFFFFB800),
                          size: 40,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Our Mission",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "To empower students by providing access to knowledge, tools, resources, and communities that help them achieve their goals and unlock their full potential.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.9,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
