import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/widgets/__family_banner.dart';

import 'package:tf_union/widgets/project_card.dart';

class HeroMobile extends StatefulWidget {
  const HeroMobile({super.key});

  @override
  State<HeroMobile> createState() => _HeroMobileState();
}

class _HeroMobileState extends State<HeroMobile> {
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
  void didUpdateWidget(HeroMobile oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    // ── Logged out — kept close to the original ──────────────────────
    if (!loggedIn) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenSize.height * 0.95),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Image.asset(
                  'assets/BlackLogo.png',
                  width: screenWidth * 0.7,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  left: 50,
                  right: 50,
                ),
                child: Text(
                  'A Non-Profit Organization \nBuilt Specially for standout students of Egypt.',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: TFColors.whitePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
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
              const SizedBox(height: 150),
            ],
          ),
        ),
      );
    }

    // ── Logged in — dashboard ──────────────────────────────────────────
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenSize.height),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Family banner ────────────────────────────────────────
              FamilyBanner(memberCount: _memberCount),

              const SizedBox(height: 20),

              // ── Greeting ───────────────────────────────────────────
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
                          ? snapshot.data!.data() as Map<String, dynamic>
                          : <String, dynamic>{};
                      final username = data['username'] as String? ?? '';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.exo2(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: TFColors.whitePrimary,
                              ),
                              children: [
                                TextSpan(text: '${_timeOfDayGreeting()}, '),
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
                          const SizedBox(height: 4),
                          Text(
                            "Here's what the union is building right now.",
                            style: GoogleFonts.exo2(
                              fontSize: 13,
                              color: TFColors.whiteSecondary,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 22),

              // ── Project stats ─────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: _doneCount,
                      label: 'Done',
                      tooltip:
                          'Projects marked as published — finished and live.',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      value: _inProgressCount,
                      label: 'In progress',
                      tooltip: 'Projects the team is actively building.',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      value: _upcomingCount,
                      label: 'Upcoming',
                      tooltip: 'Projects on the roadmap, not published yet.',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Section label ──────────────────────────────────────
              Text(
                'ACTIVE PROJECTS',
                style: GoogleFonts.exo2(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: TFColors.whiteSecondary.withValues(alpha: 0.7),
                ),
              ),

              const SizedBox(height: 12),

              // ── Project cards — centered ───────────────────────────
              projectCards.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
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
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: projectCards,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat card ────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final int value;
  final String label;
  final String tooltip;
  const _StatCard({
    required this.value,
    required this.label,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: TFColors.whitePrimary,
                ),
              ),
              Tooltip(
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
                child: Icon(
                  Icons.info_outline,
                  size: 15,
                  color: TFColors.whiteSecondary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.exo2(
              fontSize: 11,
              color: TFColors.whiteSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
