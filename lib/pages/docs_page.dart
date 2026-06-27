import 'package:flutter/material.dart';
import 'package:tf_union/constants/faq.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:google_fonts/google_fonts.dart';

class DocsPage extends StatefulWidget {
  const DocsPage({super.key});

  @override
  State<DocsPage> createState() => _DocsPageState();
}

class _DocsPageState extends State<DocsPage> {
  final ScrollController _scrollController = ScrollController();
  // Keys live here and are passed only to _FaqItem — never reused elsewhere
  late final List<GlobalKey> _sectionKeys =
      List.generate(faqs.length, (_) => GlobalKey());
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= 180) {
        if (_activeIndex != i) setState(() => _activeIndex = i);
        return;
      }
    }
    if (_activeIndex != 0) setState(() => _activeIndex = 0);
  }

  void _scrollTo(int index) {
    final ctx = _sectionKeys[index].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOut,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: TFColors.bglight1,
      appBar: _DocsAppBar(),
      body: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar
                _Sidebar(
                  activeIndex: _activeIndex,
                  onTap: _scrollTo,
                ),
                // Vertical divider
                Container(
                  width: 0.5,
                  color: TFColors.whitePrimary.withValues(alpha: 0.10),
                ),
                // Content
                Expanded(
                  child: _ContentArea(
                    scrollController: _scrollController,
                    sectionKeys: _sectionKeys,
                  ),
                ),
              ],
            )
          : _ContentArea(
              scrollController: _scrollController,
              sectionKeys: _sectionKeys,
            ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _DocsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DocsAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TFColors.bglight1,
      elevation: 0,
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          height: 0.5,
          color: TFColors.whitePrimary.withValues(alpha: 0.12),
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 16,
          color: TFColors.whitePrimary.withValues(alpha: 0.6),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Image.asset('assets/BlackLogo.png', height: 28),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 18,
            color: TFColors.whitePrimary.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 12),
          Text(
            'Docs',
            style: GoogleFonts.exo2(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: TFColors.whitePrimary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sidebar ───────────────────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _Sidebar({required this.activeIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 36, 12, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ON THIS PAGE',
              style: GoogleFonts.exo2(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
                color: TFColors.whitePrimary.withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(height: 14),
            ...List.generate(faqs.length, (i) {
              final active = i == activeIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(bottom: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: active
                          ? TFColors.yellowPrimary.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        // Active bar
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 2,
                          height: 13,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: active
                                ? TFColors.yellowPrimary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            faqs[i]['q']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.exo2(
                              fontSize: 12,
                              fontWeight: active
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: active
                                  ? TFColors.whitePrimary
                                  : TFColors.whitePrimary
                                      .withValues(alpha: 0.45),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ── Content area ──────────────────────────────────────────────────────────────
class _ContentArea extends StatelessWidget {
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;

  const _ContentArea({
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 48, 40, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Intro ──────────────────────────────────────────────────
                Text(
                  'OVERVIEW',
                  style: GoogleFonts.exo2(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                    color: TFColors.yellowPrimary.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'TF Unions',
                  style: GoogleFonts.exo2(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: TFColors.whitePrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'TF Union is an educational platform that connects students with '
                  'tools, resources, projects, and learning communities to help '
                  'them grow faster and learn in a more structured way.',
                  style: GoogleFonts.exo2(
                    fontSize: 15,
                    color: TFColors.whitePrimary.withValues(alpha: 0.65),
                    height: 1.8,
                  ),
                ),

                const SizedBox(height: 52),

                // ── Section label + rule ───────────────────────────────────
                Row(
                  children: [
                    Text(
                      'FREQUENTLY ASKED',
                      style: GoogleFonts.exo2(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        color: TFColors.whitePrimary.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Container(
                        height: 0.5,
                        color: TFColors.whitePrimary.withValues(alpha: 0.10),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── FAQ items — key goes on the outermost widget ───────────
                ...List.generate(faqs.length, (i) {
                  return _FaqItem(
                    key: sectionKeys[i],
                    question: faqs[i]['q']!,
                    answer: faqs[i]['a']!,
                    index: i,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── FAQ item ──────────────────────────────────────────────────────────────────
class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final int index;

  const _FaqItem({
    super.key,
    required this.question,
    required this.answer,
    required this.index,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  late final Animation<double> _anim =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Question row ────────────────────────────────────────────────
        GestureDetector(
          onTap: _toggle,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _expanded
                        ? Colors.transparent
                        : TFColors.whitePrimary.withValues(alpha: 0.08),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Number badge
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 1, right: 14),
                    decoration: BoxDecoration(
                      color: _expanded
                          ? TFColors.yellowPrimary.withValues(alpha: 0.18)
                          : TFColors.whitePrimary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index + 1}',
                        style: GoogleFonts.exo2(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _expanded
                              ? TFColors.yellowPrimary
                              : TFColors.whitePrimary.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                  ),
                  // Question
                  Expanded(
                    child: Text(
                      widget.question,
                      style: GoogleFonts.exo2(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _expanded
                            ? TFColors.whitePrimary
                            : TFColors.whitePrimary.withValues(alpha: 0.75),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Chevron
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: _expanded
                          ? TFColors.yellowPrimary
                          : TFColors.whitePrimary.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Answer ──────────────────────────────────────────────────────
        SizeTransition(
          sizeFactor: _anim,
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.fromLTRB(38, 4, 0, 20),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: TFColors.yellowPrimary.withValues(alpha: 0.35),
                  width: 2,
                ),
                bottom: BorderSide(
                  color: TFColors.whitePrimary.withValues(alpha: 0.08),
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              widget.answer,
              style: GoogleFonts.exo2(
                fontSize: 14,
                color: TFColors.whitePrimary.withValues(alpha: 0.60),
                height: 1.85,
              ),
            ),
          ),
        ),
      ],
    );
  }
}