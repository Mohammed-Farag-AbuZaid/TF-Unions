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
      color: TFColors.canvas,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: TFColors.tealSoft,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: TFColors.tealBorder),
              ),
              child: const Text(
                'Egyptian STEM & university scholars network',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: TFColors.gold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'A non-profit platform for standout students in Egypt.',
              style: TextStyle(
                fontFamily: 'Bricolage Grotesque',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1.12,
                letterSpacing: -0.9,
                color: TFColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Connecting students across Egypt with verified opportunities, open tools, and peer communities.',
              style: TextStyle(
                fontSize: 14.5,
                color: TFColors.muted,
                height: 1.5,
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Join TF Unions',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
        color: TFColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TFColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontFamily: 'Bricolage Grotesque',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: TFColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: TFColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
