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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
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
          const SizedBox(height: 10),
          const Text(
            'A non-profit platform for standout students in Egypt.',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.12,
              letterSpacing: -1.0,
              color: TFColors.ink,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Connecting students across Egypt with verified opportunities, tools, and learning communities.',
            style: TextStyle(
              fontSize: 15,
              color: TFColors.muted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
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
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Join TF Unions',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(height: 28),
          FamilyBanner(memberCount: _memberCount),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MobileStatCard(value: _doneCount, label: 'Done'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MobileStatCard(
                  value: _inProgressCount,
                  label: 'In progress',
                ),
              ),
              const SizedBox(width: 10),
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
        color: TFColors.tile,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: TFColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: TFColors.muted),
          ),
        ],
      ),
    );
  }
}
