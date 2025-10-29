import 'package:flutter/material.dart';
import 'package:my_portfolio/core/function/app_functions.dart';
import 'package:my_portfolio/screens/projects_screen.dart';
import 'package:my_portfolio/screens/certificates_screen.dart';
import 'package:my_portfolio/screens/contact_me_section.dart';
import 'package:my_portfolio/screens/home_section.dart';
import '../core/constant.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<int> currentSectionNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> showScrollDownButton = ValueNotifier<bool>(true);
  bool _isProgrammaticScroll = false;

  final List<GlobalKey> sectionKeys = [
    homeKey,
    aboutKey,
    projectsKey,
    certificatesKey,
    contactKey,
  ];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onNavItemSelected(String section) {
    switch (section) {
      case 'Home':
        _scrollToSection(0);
        break;
      case 'About':
        _scrollToSection(1);
        break;
      case 'Projects':
        _scrollToSection(2);
        break;
      case 'Certificates':
        _scrollToSection(3);
        break;
      case 'Contact Me':
        _scrollToSection(4);
        break;
    }
  }

  void _onScroll() {
    // Skip if it's a programmatic scroll
    if (_isProgrammaticScroll) return;

    _updateCurrentSection();
  }

  void _updateCurrentSection() {
    final scrollPosition = scrollController.position.pixels;
    final viewportHeight = MediaQuery.of(context).size.height;

    // Show/hide scroll down button based on scroll position
    final isAtBottom =
        scrollPosition >= scrollController.position.maxScrollExtent - 100;
    if (showScrollDownButton.value != !isAtBottom) {
      showScrollDownButton.value = !isAtBottom;
    }

    int? newCurrentSection;

    for (int i = 0; i < sectionKeys.length; i++) {
      final key = sectionKeys[i];
      final context = key.currentContext;
      if (context != null) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final sectionHeight = renderBox.size.height;

        // Calculate how much of the section is visible in the viewport
        final visibleHeight = _calculateVisibleHeight(
          position.dy,
          sectionHeight,
          viewportHeight,
        );

        // If more than 30% of the section is visible, consider it active
        if (visibleHeight > sectionHeight * 0.3) {
          newCurrentSection = i;
          break;
        }
      }
    }

    // Update only if we found a new section and it's different from current
    if (newCurrentSection != null &&
        newCurrentSection != currentSectionNotifier.value) {
      currentSectionNotifier.value = newCurrentSection;
    }
  }

  double _calculateVisibleHeight(
    double sectionTop,
    double sectionHeight,
    double viewportHeight,
  ) {
    final sectionBottom = sectionTop + sectionHeight;
    final viewportTop = scrollController.position.pixels;
    final viewportBottom = viewportTop + viewportHeight;

    final visibleTop = sectionTop.clamp(viewportTop, viewportBottom);
    final visibleBottom = sectionBottom.clamp(viewportTop, viewportBottom);

    return visibleBottom - visibleTop;
  }

  void _scrollToSection(int index) {
    currentSectionNotifier.value = index;
    _isProgrammaticScroll = true;

    final context = sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1,
      ).then((_) {
        // Reset the flag after scroll completes
        Future.delayed(const Duration(milliseconds: 300), () {
          _isProgrammaticScroll = false;
          _updateCurrentSection();
        });
      });
    } else {
      _isProgrammaticScroll = false;
    }
  }

  void _scrollToNextSection() {
    final currentIndex = currentSectionNotifier.value;
    if (currentIndex < sectionKeys.length - 1) {
      _scrollToSection(currentIndex + 1);
    } else {
      _scrollToSection(0);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    currentSectionNotifier.dispose();
    showScrollDownButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: _CustomScrollBehavior(),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  // Header with ValueListenableBuilder
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _CustomHeaderDelegate(
                      child: ValueListenableBuilder<int>(
                        valueListenable: currentSectionNotifier,
                        builder: (context, currentIndex, child) {
                          return Header(
                            currentIndex: currentIndex,
                            onNavItemSelected: _onNavItemSelected,
                          );
                        },
                      ),
                    ),
                  ),

                  // Sections
                  SliverToBoxAdapter(child: HomeSection(key: homeKey)),

                  SliverToBoxAdapter(child: _buildSectionDivider()),

                  SliverToBoxAdapter(
                    child: AboutScreen(
                      onHireMe: () => _scrollToSection(4),
                      key: aboutKey,
                    ),
                  ),

                  SliverToBoxAdapter(child: _buildSectionDivider()),

                  SliverToBoxAdapter(key: projectsKey, child: ProjectsScreen()),

                  SliverToBoxAdapter(child: _buildSectionDivider()),

                  SliverToBoxAdapter(
                    key: certificatesKey,
                    child: CertificatesScreen(),
                  ),

                  SliverToBoxAdapter(child: _buildSectionDivider()),

                  SliverToBoxAdapter(
                    key: contactKey,
                    child: ContactMeSection(),
                  ),

                  SliverToBoxAdapter(child: Footer()),
                ],
              ),
            ),

            // Custom Scrollbar
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: _buildCustomScrollbar(),
            ),

            // Scroll Down Button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: _buildScrollDownButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollDownButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: showScrollDownButton,
      builder: (context, showButton, child) {
        return AnimatedOpacity(
          opacity: showButton ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: AnimatedSlide(
            offset: showButton ? Offset.zero : const Offset(0, 1),
            duration: const Duration(milliseconds: 400),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _scrollToNextSection,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFAA6BE4).withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFAA6BE4).withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFFAA6BE4),
                    size: 32,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Scroll',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomScrollbar() {
    return ValueListenableBuilder<int>(
      valueListenable: currentSectionNotifier,
      builder: (context, currentIndex, child) {
        return Container(
          width: 12,
          margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 4),
          child: CustomPaint(
            painter: _ScrollbarPainter(
              scrollController: scrollController,
              currentSection: currentIndex,
              totalSections: sectionKeys.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFAA6BE4).withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class _ScrollbarPainter extends CustomPainter {
  final ScrollController scrollController;
  final int currentSection;
  final int totalSections;

  _ScrollbarPainter({
    required this.scrollController,
    required this.currentSection,
    required this.totalSections,
  }) : super(repaint: scrollController);

  @override
  void paint(Canvas canvas, Size size) {
    final scrollPosition = scrollController.position;
    final totalExtent =
        scrollPosition.maxScrollExtent + scrollPosition.viewportDimension;
    final thumbOffset = (scrollPosition.pixels / totalExtent) * size.height;
    final thumbHeight =
        (scrollPosition.viewportDimension / totalExtent) * size.height;

    // Background
    final backgroundPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    final backgroundRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 3,
        height: size.height,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(backgroundRRect, backgroundPaint);

    // Section indicators
    final sectionHeight = size.height / totalSections;
    for (int i = 0; i < totalSections; i++) {
      final isActive = i == currentSection;
      final indicatorPaint =
          Paint()
            ..color =
                isActive
                    ? const Color(0xFFAA6BE4)
                    : Colors.white.withOpacity(0.3)
            ..style = PaintingStyle.fill;

      final indicatorRect = Rect.fromCenter(
        center: Offset(size.width / 2, i * sectionHeight + sectionHeight / 2),
        width: isActive ? 6 : 3,
        height: 3,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(indicatorRect, const Radius.circular(2)),
        indicatorPaint,
      );
    }

    // Scroll thumb
    final thumbPaint =
        Paint()
          ..color = const Color(0xFFAA6BE4)
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            colors: [const Color(0xFFAA6BE4), const Color(0xFF6B8AFF)],
          ).createShader(
            Rect.fromPoints(
              Offset(0, thumbOffset),
              Offset(size.width, thumbOffset + thumbHeight),
            ),
          );

    final thumbRRect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(0, thumbOffset),
        Offset(
          size.width,
          thumbOffset + thumbHeight.clamp(20, double.infinity),
        ),
      ),
      const Radius.circular(6),
    );

    canvas.drawRRect(thumbRRect, thumbPaint);

    // Thumb border
    final borderPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    canvas.drawRRect(thumbRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _ScrollbarPainter oldDelegate) {
    return scrollController != oldDelegate.scrollController ||
        currentSection != oldDelegate.currentSection ||
        totalSections != oldDelegate.totalSections;
  }
}

class _CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CustomHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F23).withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
