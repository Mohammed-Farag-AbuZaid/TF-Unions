import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/utils/tf_api.dart';
import 'package:tf_union/widgets/project_card.dart';

enum ProjectFilter { all, done, inProgress, upcoming }

class ProjectsPage extends StatefulWidget {
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
    final orgsList = await TfApiService.fetchCollection('orgs');
    final allProjectsList = await TfApiService.fetchCollection('allProjects');
    final inProgressList =
        await TfApiService.fetchCollection('inProgressProjects');

    Widget card(Map<String, dynamic> doc) => buildProjectCard(
          title: (doc['name'] ?? '').toString(),
          description: (doc['description'] ?? '').toString(),
          imagePath: (doc['imgURL'] ?? '').toString(),
          projectUrl: (doc['projectURL'] ?? '').toString(),
          published: doc['published'] == true,
        );

    String keyOf(Map<String, dynamic> doc) =>
        (doc['name'] ?? '').toString().trim().toLowerCase();

    final claimedKeys = <String>{};

    final inProgressCards = <Widget>[];
    for (final doc in inProgressList) {
      if (!claimedKeys.add(keyOf(doc))) continue;
      inProgressCards.add(card(doc));
    }

    final doneCards = <Widget>[];
    final upcomingCards = <Widget>[];
    for (final doc in allProjectsList) {
      if (!claimedKeys.add(keyOf(doc))) continue;
      if (doc['published'] == true) {
        doneCards.add(card(doc));
      } else {
        upcomingCards.add(card(doc));
      }
    }

    if (!mounted) return;
    setState(() {
      _orgCards = orgsList.map(card).toList();
      _doneCards = doneCards;
      _inProgressCards = inProgressCards;
      _upcomingCards = upcomingCards;
      _allCards = [...doneCards, ...inProgressCards, ...upcomingCards];
      _loading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _PageHeader(),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TFColors.accent,
                    ),
                  ),
                ),
              )
            else if (_orgCards.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'TF SUB-ORGS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: TFColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _orgCards,
                ),
              ),
              const SizedBox(height: 48),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: TFColors.tile,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  onTap: (_) => setState(() {}),
                  isScrollable: false,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: TFColors.ink,
                  unselectedLabelColor: TFColors.muted,
                  tabs: _tabLabels
                      .map((l) => Tab(text: l, height: 36))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 28),
            if (!_loading) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _activeCards.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No projects in this filter right now.',
                          style: TextStyle(color: TFColors.muted, fontSize: 14),
                        ),
                      )
                    : Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: _activeCards,
                      ),
              ),
              const SizedBox(height: 64),
            ],
          ],
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 56, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services & Projects',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: TFColors.ink,
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Everything the union is building — past, present and future.',
            style: TextStyle(
              fontSize: 16,
              color: TFColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
