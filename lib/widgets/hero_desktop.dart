import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/social_items.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/pages/projects_page.dart';
import 'package:tf_union/widgets/__family_banner.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

import 'package:tf_union/widgets/project_card.dart';

class HeroDesktop extends StatefulWidget {
  const HeroDesktop({super.key});

  @override
  State<HeroDesktop> createState() => _HeroDesktopState();
}

class _HeroDesktopState extends State<HeroDesktop> {
  final db = FirebaseFirestore.instance;
  List<Widget> projectCards = [];

  int _memberCount = 0;
  int _doneCount = 0;
  int _inProgressCount = 0;
  int _upcomingCount = 0;
  bool _statsLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
    if (loggedIn) getStats();
  }

  @override
  void didUpdateWidget(HeroDesktop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (loggedIn && !_statsLoaded) getStats();
  }

  Future<void> getData() async {
    final snapshot = await db
        .collection('allProjects')
        .where('published', isEqualTo: true)
        .get();
    projectCards.clear();

    for (var doc in snapshot.docs) {
      projectCards.add(
        buildProjectCard(
          title: doc['name'],
          description: doc['description'],
          imagePath: doc['imgURL'],
          projectUrl: doc['projectURL'],
          published: doc['published'],
        ),
      );
    }

    setState(() {});
  }

  Future<void> getStats() async {
    final members = await db.collection('users').count().get();
    final done = await db
        .collection('allProjects')
        .where('published', isEqualTo: true)
        .count()
        .get();
    final inProgress = await db.collection('inProgressProjects').count().get();
    final upcoming = await db
        .collection('allProjects')
        .where('published', isEqualTo: false)
        .count()
        .get();

    setState(() {
      _memberCount = members.count ?? 0;
      _doneCount = done.count ?? 0;
      _inProgressCount = inProgress.count ?? 0;
      _upcomingCount = upcoming.count ?? 0;
      _statsLoaded = true;
    });
  }

  String _timeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  void _goToProjects(ProjectFilter filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: SingleChildScrollView(
            child: ProjectsPage(initialFilter: filter),
          ),
        ),
      ),
    );
  }

  static const _socialUrls = [
    'https://www.youtube.com/',
    'https://www.facebook.com/',
    'https://chat.whatsapp.com/DSiidKAP0TP84vXA9Pand7',
    'https://www.instagram.com/',
  ];

  static const _socialLabels = [
    'YouTube',
    'Facebook',
    'WhatsApp',
    'Instagram',
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    // ── Logged out ────────────────────────────────────────────────────────────
    if (!loggedIn) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: screenSize.height * 0.93,
        ),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'A Non-Profit Platform \nBuilt Specially for standout students of Egypt.',
                style: GoogleFonts.robotoSlab(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: TFColors.whitePrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TFColors.yellowPrimary,
                    foregroundColor: TFColors.whitePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Join us',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                children: [
                  const Spacer(),
                  const Spacer(),
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < socialItems.length; i++)
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                if (i < _socialUrls.length) {
                                  js.context
                                      .callMethod('open', [_socialUrls[i]]);
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

    // ── Logged in — dashboard ─────────────────────────────────────────────────
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenSize.height),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Family banner ──────────────────────────────────────────
                  FamilyBanner(memberCount: _memberCount),

                  const SizedBox(height: 28),

                  // ── Greeting ───────────────────────────────────────────────
                  ValueListenableBuilder(
                    valueListenable: currentUser,
                    builder: (context, user, _) {
                      return StreamBuilder<DocumentSnapshot>(
                        stream: user != null
                            ? FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .snapshots()
                            : const Stream.empty(),
                        builder: (context, snapshot) {
                          final data = snapshot.data?.exists == true
                              ? snapshot.data!.data()
                                  as Map<String, dynamic>
                              : <String, dynamic>{};
                          final username =
                              data['username'] as String? ?? '';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.exo2(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: TFColors.whitePrimary,
                                  ),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${_timeOfDayGreeting()}, '),
                                    TextSpan(
                                      text: username.isNotEmpty
                                          ? '@$username'
                                          : 'there',
                                      style: const TextStyle(
                                        color: TFColors.yellowPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Here's what the union is building right now.",
                                style: GoogleFonts.exo2(
                                  fontSize: 14,
                                  color: TFColors.whiteSecondary,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // ── Project stats ──────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: _doneCount,
                          label: 'Done',
                          tooltip:
                              'Projects marked as published — finished and live.',
                          onTap: () => _goToProjects(ProjectFilter.done),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          value: _inProgressCount,
                          label: 'In progress',
                          tooltip:
                              'Projects the team is actively building.',
                          onTap: () =>
                              _goToProjects(ProjectFilter.inProgress),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          value: _upcomingCount,
                          label: 'Upcoming',
                          tooltip:
                              'Projects on the roadmap, not published yet.',
                          onTap: () =>
                              _goToProjects(ProjectFilter.upcoming),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ── Section label ──────────────────────────────────────────
                  Text(
                    'ACTIVE PROJECTS',
                    style: GoogleFonts.exo2(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                      color: TFColors.whiteSecondary.withValues(alpha: 0.7),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Project cards ──────────────────────────────────────────
                  projectCards.isEmpty
                      ? Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No active projects yet — check back soon.',
                              style: GoogleFonts.exo2(
                                fontSize: 13,
                                color: TFColors.whiteSecondary,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            children: projectCards,
                          ),
                        ),

                  const SizedBox(height: 48),

                  // ── Social links ───────────────────────────────────────────
                  Container(
                    height: 0.5,
                    color: TFColors.whiteSecondary.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < socialItems.length; i++)
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            onPressed: () {
                              if (i < _socialUrls.length) {
                                js.context.callMethod('open', [_socialUrls[i]]);
                              }
                            },
                            icon: socialItems[i],
                            tooltip: _socialLabels[i],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Follow us on social media',
                      style: GoogleFonts.exo2(
                        fontSize: 11,
                        color: TFColors.whiteSecondary.withValues(alpha: 0.35),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final int value;
  final String label;
  final String tooltip;
  final VoidCallback? onTap;

  const _StatCard({
    required this.value,
    required this.label,
    required this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      triggerMode: TooltipTriggerMode.tap,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      textStyle: GoogleFonts.exo2(
        fontSize: 12,
        color: TFColors.whitePrimary,
      ),
      decoration: BoxDecoration(
        color: TFColors.bglight1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: TFColors.whiteSecondary.withValues(alpha: 0.25),
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: TFColors.whitePrimary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: TFColors.whiteSecondary.withValues(alpha: 0.18),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value.toString(),
                      style: GoogleFonts.exo2(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: TFColors.whitePrimary,
                      ),
                    ),
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: TFColors.whiteSecondary.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: GoogleFonts.exo2(
                    fontSize: 12,
                    color: TFColors.whiteSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}