import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/pages/projects_page.dart';
import 'package:tf_union/utils/tf_api.dart';
import 'package:tf_union/widgets/__family_banner.dart';
import 'package:tf_union/widgets/project_card.dart';

class HeroDesktop extends StatefulWidget {
  const HeroDesktop({super.key});

  @override
  State<HeroDesktop> createState() => _HeroDesktopState();
}

class _HeroDesktopState extends State<HeroDesktop> {
  List<Widget> projectCards = [];

  int _memberCount = 50;
  int _doneCount = 0;
  int _inProgressCount = 0;
  int _upcomingCount = 0;
  bool _statsLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
    getStats();
  }

  Future<void> getData() async {
    final items = await TfApiService.fetchCollection('allProjects');
    projectCards.clear();
    for (var doc in items) {
      if (doc['published'] == true) {
        projectCards.add(
          buildProjectCard(
            title: (doc['name'] ?? '').toString(),
            description: (doc['description'] ?? '').toString(),
            imagePath: (doc['imgURL'] ?? '').toString(),
            projectUrl: (doc['projectURL'] ?? '').toString(),
            published: true,
          ),
        );
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> getStats() async {
    final users = await TfApiService.fetchCollection('users');
    final allProjects = await TfApiService.fetchCollection('allProjects');
    final inProgress = await TfApiService.fetchCollection('inProgressProjects');

    if (!mounted) return;
    setState(() {
      _memberCount = users.isNotEmpty ? users.length : 50;
      _doneCount = allProjects.where((d) => d['published'] == true).length;
      _inProgressCount = inProgress.length;
      _upcomingCount = allProjects.where((d) => d['published'] != true).length;
      _statsLoaded = true;
    });
  }

  void _goToProjects(ProjectFilter filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: TFColors.canvas,
          body: SingleChildScrollView(
            child: ProjectsPage(initialFilter: filter),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: TFColors.navy,
        border: Border(
          bottom: BorderSide(color: TFColors.navyLine, width: 1),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 40, height: 3, color: TFColors.gold),
                      const SizedBox(height: 16),
                      const Text(
                        'Egyptian STEM & University Scholars Network',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: TFColors.gold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'A non-profit institution built for standout students in Egypt.',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          height: 1.08,
                          letterSpacing: -1.3,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Connecting ambitious students across Egypt with verified university pathways, open-source engineering tools, and scholarly communities.',
                        style: TextStyle(
                          fontSize: 16.5,
                          color: Color(0xFFD6DCE8),
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (!loggedIn)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TFColors.accent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(
                                    color: Color(0xFF2853B8),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Join TF Unions',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          OutlinedButton(
                            onPressed: () => _goToProjects(ProjectFilter.all),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: TFColors.navyAlt,
                              side: const BorderSide(color: TFColors.navyLine),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Browse Projects',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  flex: 5,
                  child: _statsLoaded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FamilyBanner(memberCount: _memberCount),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    value: _doneCount,
                                    label: 'Published services',
                                    onTap: () =>
                                        _goToProjects(ProjectFilter.done),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    value: _inProgressCount,
                                    label: 'In progress',
                                    onTap: () =>
                                        _goToProjects(ProjectFilter.inProgress),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    value: _upcomingCount,
                                    label: 'Upcoming',
                                    onTap: () =>
                                        _goToProjects(ProjectFilter.upcoming),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: TFColors.navyAlt,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: TFColors.navyLine),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: TFColors.gold,
                              strokeWidth: 2,
                            ),
                          ),
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

class _StatCard extends StatelessWidget {
  final int value;
  final String label;
  final VoidCallback? onTap;

  const _StatCard({
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: TFColors.navyAlt,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: TFColors.navyLine),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFD6DCE8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
