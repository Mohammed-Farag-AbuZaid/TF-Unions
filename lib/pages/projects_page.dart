import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/project_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Filter enum – shared with HeroDesktop so stat cards can pass a filter value
// ─────────────────────────────────────────────────────────────────────────────
enum ProjectFilter { all, done, inProgress, upcoming }

// ─────────────────────────────────────────────────────────────────────────────
// ProjectsPage
// ─────────────────────────────────────────────────────────────────────────────
class ProjectsPage extends StatefulWidget {
  /// When non-null the tab matching [initialFilter] is pre-selected on mount,
  /// so tapping a stat card on the Hero jumps straight to the right section.
  final ProjectFilter initialFilter;

  const ProjectsPage({
    super.key,
    this.initialFilter = ProjectFilter.all,
  });

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage>
    with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;

  // Raw card lists per category
  List<Widget> _orgCards = [];
  List<Widget> _doneCards = [];
  List<Widget> _inProgressCards = [];
  List<Widget> _upcomingCards = [];
  List<Widget> _allCards = [];

  bool _loading = true;

  late TabController _tabController;

  static const _tabs = [
    ProjectFilter.all,
    ProjectFilter.done,
    ProjectFilter.inProgress,
    ProjectFilter.upcoming,
  ];

  static const _tabLabels = ['All', 'Done', 'In Progress', 'Upcoming'];

  @override
  void initState() {
    super.initState();
    final initialIndex = _tabs.indexOf(widget.initialFilter);
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: initialIndex < 0 ? 0 : initialIndex,
    );
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    // Orgs
    final orgsSnap = await db.collection('orgs').get();

    // Done = published allProjects
    final doneSnap = await db
        .collection('allProjects')
        .where('published', isEqualTo: true)
        .get();

    // In Progress
    final inProgressSnap = await db.collection('inProgressProjects').get();

    // Upcoming = unpublished allProjects
    final upcomingSnap = await db
        .collection('allProjects')
        .where('published', isEqualTo: false)
        .get();

    Widget card(DocumentSnapshot doc) => buildProjectCard(
          title: doc['name'],
          description: doc['description'],
          imagePath: doc['imgURL'],
          projectUrl: doc['projectURL'],
          published: doc['published'],
        );

    // ── Dedupe guard ──────────────────────────────────────────────────────
    // The SAME project can exist as *separate Firestore documents* in more
    // than one collection — e.g. someone adds it to `inProgressProjects`
    // when work starts, but never removes/updates its old entry in
    // `allProjects`, so it also still matches the "upcoming" query. Because
    // these are different documents, deduping by `doc.id` doesn't catch it —
    // we have to dedupe by a content key that identifies "the same project"
    // regardless of which collection it's sitting in.
    //
    // Using the normalized project name here. If two genuinely different
    // projects could share a name, swap this for a more unique field (e.g.
    // `projectURL`, or a shared `projectId` you add to every document).
    String keyOf(DocumentSnapshot doc) =>
        (doc['name'] as String).trim().toLowerCase();

    // Claim keys in priority order: inProgress > done > upcoming.
    // Change the order if you want a different collection to "win" when a
    // project is mis-filed in two places.
    final claimedKeys = <String>{};

    final inProgressCards = <Widget>[];
    for (final doc in inProgressSnap.docs) {
      if (!claimedKeys.add(keyOf(doc))) continue;
      inProgressCards.add(card(doc));
    }

    final doneCards = <Widget>[];
    for (final doc in doneSnap.docs) {
      if (!claimedKeys.add(keyOf(doc))) continue; // already claimed elsewhere
      doneCards.add(card(doc));
    }

    final upcomingCards = <Widget>[];
    for (final doc in upcomingSnap.docs) {
      if (!claimedKeys.add(keyOf(doc))) continue; // already claimed elsewhere
      upcomingCards.add(card(doc));
    }

    setState(() {
      _orgCards = orgsSnap.docs.map(card).toList();
      _doneCards = doneCards;
      _inProgressCards = inProgressCards;
      _upcomingCards = upcomingCards;
      _allCards = [...doneCards, ...inProgressCards, ...upcomingCards];
      _loading = false;
    });
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  List<Widget> get _activeCards {
    switch (_tabs[_tabController.index]) {
      case ProjectFilter.done:
        return _doneCards;
      case ProjectFilter.inProgress:
        return _inProgressCards;
      case ProjectFilter.upcoming:
        return _upcomingCards;
      case ProjectFilter.all:
        return _allCards;
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Page header ──────────────────────────────────────────────────────
        _PageHeader(),

        // ── Sub-orgs section (not affected by filters) ───────────────────────
        if (_loading)
          const _LoadingIndicator()
        else if (_orgCards.isNotEmpty) ...[
          _SectionLabel(label: 'TF SUB-ORGS'),
          const SizedBox(height: 20),
          _CardGrid(cards: _orgCards),
          const SizedBox(height: 48),
        ],

        // ── Filter tabs ──────────────────────────────────────────────────────
        _FilterTabBar(
          controller: _tabController,
          labels: _tabLabels,
          onTap: (_) => setState(() {}),
        ),

        const SizedBox(height: 32),

        // ── Projects section ─────────────────────────────────────────────────
        if (!_loading) ...[
          _SectionLabel(label: _sectionLabel),
          const SizedBox(height: 20),
          _activeCards.isEmpty
              ? _EmptyState(filter: _tabs[_tabController.index])
              : _CardGrid(cards: _activeCards),

          const SizedBox(height: 60),
        ],
      ],
    );
  }

  String get _sectionLabel {
    switch (_tabs[_tabController.index]) {
      case ProjectFilter.done:
        return 'FINISHED PROJECTS';
      case ProjectFilter.inProgress:
        return 'IN-PROGRESS PROJECTS';
      case ProjectFilter.upcoming:
        return 'UPCOMING PROJECTS';
      case ProjectFilter.all:
        return 'ALL PROJECTS';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Services & Projects',
              textAlign: TextAlign.center,
              style: GoogleFonts.exo2(
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: TFColors.whitePrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              height: 3,
              width: 180,
              decoration: BoxDecoration(
                color: TFColors.yellowPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Everything the union is building — past, present and future.",
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(
              fontSize: 14,
              color: TFColors.whiteSecondary.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Filter tab bar ────────────────────────────────────────────────────────────
class _FilterTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> labels;
  final ValueChanged<int> onTap;

  const _FilterTabBar({
    required this.controller,
    required this.labels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: TFColors.whitePrimary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: TFColors.whiteSecondary.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: controller,
          onTap: onTap,
          isScrollable: false,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: TFColors.yellowPrimary,
            borderRadius: BorderRadius.circular(9),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: GoogleFonts.exo2(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.exo2(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          labelColor: TFColors.hintDark, // dark text on yellow pill
          unselectedLabelColor:
              TFColors.whiteSecondary.withValues(alpha: 0.7),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: labels.map((l) => Tab(text: l, height: 36)).toList(),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        label,
        style: GoogleFonts.exo2(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.6,
          color: TFColors.whiteSecondary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

// ── Card grid ─────────────────────────────────────────────────────────────────
class _CardGrid extends StatelessWidget {
  final List<Widget> cards;
  const _CardGrid({required this.cards});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: cards,
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final ProjectFilter filter;
  const _EmptyState({required this.filter});

  String get _message {
    switch (filter) {
      case ProjectFilter.done:
        return 'No finished projects yet — check back soon.';
      case ProjectFilter.inProgress:
        return 'Nothing actively in progress right now.';
      case ProjectFilter.upcoming:
        return "The roadmap is being planned — stay tuned.";
      case ProjectFilter.all:
        return 'No projects yet — check back soon.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Text(
        _message,
        style: GoogleFonts.exo2(
          fontSize: 13,
          color: TFColors.whiteSecondary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

// ── Loading indicator ─────────────────────────────────────────────────────────
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: TFColors.yellowPrimary,
          ),
        ),
      ),
    );
  }
}