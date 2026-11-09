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
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: ProjectsPage(initialFilter: filter),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TF UNIONS FOUNDATION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: TFColors.muted,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'A non-profit platform built\nfor standout students in Egypt.',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  height: 1.08,
                  letterSpacing: -1.5,
                  color: TFColors.ink,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Connecting ambitious students across Egypt with verified opportunities, open-source engineering tools, and peer communities.',
                style: TextStyle(
                  fontSize: 18,
                  color: TFColors.muted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
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
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Join TF Unions',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              const SizedBox(height: 40),
              if (_statsLoaded) ...[
                FamilyBanner(memberCount: _memberCount),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        value: _doneCount,
                        label: 'Published services',
                        onTap: () => _goToProjects(ProjectFilter.done),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        value: _inProgressCount,
                        label: 'In progress',
                        onTap: () => _goToProjects(ProjectFilter.inProgress),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        value: _upcomingCount,
                        label: 'Upcoming',
                        onTap: () => _goToProjects(ProjectFilter.upcoming),
                      ),
                    ),
                  ],
                ),
              ],
            ],
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
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: TFColors.tile,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: TFColors.ink,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: TFColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
