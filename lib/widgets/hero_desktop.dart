import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/docs_page.dart';
import 'package:tf_union/pages/home_page.dart';
import 'package:tf_union/pages/login.dart';
import 'package:tf_union/pages/projects_page.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/utils/tf_api.dart';
import 'package:tf_union/widgets/__family_banner.dart';
import 'package:tf_union/widgets/costum_dialog.dart';
import 'package:tf_union/widgets/tf_logo_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroDesktop extends StatefulWidget {
  const HeroDesktop({super.key});

  @override
  State<HeroDesktop> createState() => _HeroDesktopState();
}

class _HeroDesktopState extends State<HeroDesktop> {
  int _memberCount = 50;
  int _doneCount = 0;
  int _inProgressCount = 0;
  int _upcomingCount = 0;
  bool _statsLoaded = false;

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
      _statsLoaded = true;
    });
  }

  void _goToProjects(ProjectFilter filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectsScreen(initialFilter: filter),
      ),
    );
  }

  void _goToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: TFColors.canvas,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Calm inline navigation & identity row (no full-width top bar)
                ValueListenableBuilder(
                  valueListenable: currentUser,
                  builder: (context, user, _) {
                    return Container(
                      padding: const EdgeInsets.only(bottom: 18),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: TFColors.border, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Row(
                            children: [
                              TfLogoMark(size: 28),
                              SizedBox(width: 10),
                              Text(
                                'TF Unions',
                                style: TextStyle(
                                  fontFamily: 'Bricolage Grotesque',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: TFColors.ink,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => _goToPage(const AboutScreen()),
                            child: const Text(
                              'About',
                              style: TextStyle(color: TFColors.muted, fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _goToProjects(ProjectFilter.all),
                            child: const Text(
                              'Projects',
                              style: TextStyle(color: TFColors.muted, fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _goToPage(const DocsPage()),
                            child: const Text(
                              'Docs',
                              style: TextStyle(color: TFColors.muted, fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton(
                            onPressed: () => launchUrl(
                              Uri.parse('https://www.tfunions.com/team/'),
                              mode: LaunchMode.externalApplication,
                            ),
                            child: const Text(
                              'Team',
                              style: TextStyle(color: TFColors.muted, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (user == null) ...[
                            OutlinedButton(
                              onPressed: () => _goToPage(const LoginPage()),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: TFColors.ink,
                                backgroundColor: TFColors.surface,
                                side: const BorderSide(color: TFColors.border),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Sign in', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _goToPage(const RegisterPage()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TFColors.accent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Join TF Unions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                          ] else
                            GestureDetector(
                              onTap: () => showProfileDialog(context: context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: TFColors.tealSoft,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: TFColors.tealBorder),
                                ),
                                child: Text(
                                  (user.displayName ?? user.email?.split('@').first ?? 'Scholar').trim(),
                                  style: const TextStyle(
                                    color: TFColors.gold,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 44),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: TFColors.tealSoft,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: TFColors.tealBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: TFColors.gold,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 7),
                            const Text(
                              'Egyptian STEM & university scholars network',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: TFColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'A non-profit institution built for standout students in Egypt.',
                        style: TextStyle(
                          fontFamily: 'Bricolage Grotesque',
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          height: 1.08,
                          letterSpacing: -1.3,
                          color: TFColors.ink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Connecting ambitious students across Egypt with verified university pathways, open-source engineering tools, and scholarly communities.',
                        style: TextStyle(
                          fontSize: 16.5,
                          color: TFColors.muted,
                          height: 1.6,
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Join TF Unions',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          OutlinedButton(
                            onPressed: () => _goToProjects(ProjectFilter.all),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: TFColors.ink,
                              backgroundColor: TFColors.surface,
                              side: const BorderSide(color: TFColors.border),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Browse projects',
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
                            color: TFColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: TFColors.border),
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
          color: TFColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TFColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A161A22),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontFamily: 'Bricolage Grotesque',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: TFColors.ink,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: TFColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
