import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/utils/tf_api.dart';
import 'package:tf_union/widgets/__family_banner.dart';

class HeroMobile extends StatefulWidget {
  const HeroMobile({super.key});

  @override
  State<HeroMobile> createState() => _HeroMobileState();
}

class _HeroMobileState extends State<HeroMobile> {
  int _memberCount = 50;
  int _doneCount = 0;
  int _inProgressCount = 0;
  int _upcomingCount = 0;

  @override
  void initState() {
    super.initState();
    getStats();
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
    });
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 36, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 32, height: 3, color: TFColors.gold),
            const SizedBox(height: 12),
            const Text(
              'Egyptian STEM & University Scholars Network',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: TFColors.gold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A non-profit platform for standout students in Egypt.',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1.12,
                letterSpacing: -0.9,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Connecting students across Egypt with verified opportunities, open tools, and peer communities.',
              style: TextStyle(
                fontSize: 14.5,
                color: Color(0xFFD6DCE8),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
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
                    horizontal: 20,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: const BorderSide(color: Color(0xFF2853B8)),
                  ),
                ),
                child: const Text(
                  'Join TF Unions',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            const SizedBox(height: 24),
            FamilyBanner(memberCount: _memberCount),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MobileStatCard(value: _doneCount, label: 'Done'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MobileStatCard(
                    value: _inProgressCount,
                    label: 'In progress',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MobileStatCard(
                    value: _upcomingCount,
                    label: 'Upcoming',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileStatCard extends StatelessWidget {
  final int value;
  final String label;
  const _MobileStatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFD6DCE8),
            ),
          ),
        ],
      ),
    );
  }
}
