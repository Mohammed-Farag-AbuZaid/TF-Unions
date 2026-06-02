import 'package:flutter/material.dart';

void main() {
  runApp(const TFUnionApp());
}

class TFUnionApp extends StatelessWidget {
  const TFUnionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DocsPage(),
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
        "a": "TF Union is an educational platform designed to help students and learners."
      },
      {
        "q": "Why was TF Union created?",
        "a": "To organize learning resources and reduce confusion for students."
      },
      {
        "q": "Who is TF Union for?",
        "a": "Students, learners, and anyone who wants to improve their skills."
      },
      {
        "q": "What services does TF Union provide?",
        "a": "Guides, projects, and educational tools (still in development)."
      },
      {
        "q": "Are all services available now?",
        "a": "No, some parts are still under development."
      },
      {
        "q": "What are educational projects?",
        "a": "Simple ideas that help students practice and build experience."
      },
      {
        "q": "What are Guides?",
        "a": "Structured learning paths to help students learn step by step."
      },
      {
        "q": "Is the platform free?",
        "a": "Yes, it is designed to be free for students."
      },
      {
        "q": "What is TF Union’s vision?",
        "a": "To become a helpful educational hub for students in the future."
      },
      {
        "q": "What are the future plans?",
        "a": "To develop tools, improve content, and expand gradually."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("TF Union Docs"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(height: 10),

          // TITLE
          const Text(
            "TF Union Docs",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // INTRO (Docs description)
          const Text(
            "TF Union is an educational platform focused on helping students and learners by organizing resources, guides, and projects in one place. "
            "This documentation is a simple starting version that explains the main idea behind the platform.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          const Divider(),

          const SizedBox(height: 10),

          // FAQ LIST
          ...faqs.map(
            (faq) => Card(
              child: ExpansionTile(
                title: Text(faq["q"]!),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(faq["a"]!),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
