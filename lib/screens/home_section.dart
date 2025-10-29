import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/function/app_functions.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/core/constant.dart';
import 'package:my_portfolio/core/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({super.key});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 1000;
        final bool isDesktop = width >= 1000;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withValues(alpha: 0.9),
                AppColors.burbleColor.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.9),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile
                      ? 20
                      : isTablet
                      ? 40
                      : 80,
              vertical: isMobile ? 40 : 80,
            ),
            child: Column(
              children: [
                if (isMobile || isTablet)
                  Column(
                    children: [
                      _buildAnimatedImage(isMobile, isTablet),
                      const SizedBox(height: 40),
                      _buildTextContent(isMobile || isTablet, width),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _buildTextContent(false, width)),
                      const SizedBox(width: 40),
                      _buildAnimatedImage(isMobile, isTablet),
                    ],
                  ),
                const SizedBox(height: 40),
                _buildAnimatedDivider(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedImage(bool isMobile, bool isTablet) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.burbleColor.withValues(alpha: 0.3),
              Colors.transparent,
            ],
            stops: const [0.1, 0.9],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.burbleColor.withValues(alpha: 0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width:
                  isMobile
                      ? 220
                      : isTablet
                      ? 280
                      : 350,
              height:
                  isMobile
                      ? 220
                      : isTablet
                      ? 280
                      : 350,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
            ),
            ClipOval(
              child: Image.asset(
                Constants.myImage,
                width:
                    isMobile
                        ? 250
                        : isTablet
                        ? 350
                        : 450,
                height:
                    isMobile
                        ? 250
                        : isTablet
                        ? 350
                        : 450,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              right: isMobile ? 10 : 20,
              child: Container(
                width: isMobile ? 20 : 30,
                height: isMobile ? 20 : 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.burbleColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.burbleColor.withValues(alpha: 0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent(bool isSmallScreen, double width) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment:
              isSmallScreen
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment:
                  isSmallScreen
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children: [
                Text.rich(
                  textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Hi, I'm ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 24 : 36,
                          fontWeight: FontWeight.w300,
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: Constants.myName,
                        style: TextStyle(
                          color: AppColors.burbleColor,
                          fontSize: isSmallScreen ? 28 : 42,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: AppColors.burbleColor.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text: "\nPassionate",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 24 : 36,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimatedTitles(isSmallScreen),
              ],
            ),
            const SizedBox(height: 40),
            _buildActionButtons(isSmallScreen, width),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTitles(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.burbleColor.withValues(alpha: 0.1),
            AppColors.burbleColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.burbleColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: isMobile ? 26 : 38.0,
          fontWeight: FontWeight.bold,
          color: AppColors.burbleColor,
          shadows: [
            Shadow(
              color: AppColors.burbleColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: AnimatedTextKit(
          repeatForever: true,
          pause: const Duration(milliseconds: 1000),
          animatedTexts: [
            TypewriterAnimatedText(
              'Flutter Developer',
              speed: const Duration(milliseconds: 80),
              curve: Curves.easeInOut,
            ),
            TypewriterAnimatedText(
              'Computer Science',
              speed: const Duration(milliseconds: 80),
              curve: Curves.easeInOut,
            ),
            TypewriterAnimatedText(
              'Flutter Instructor',
              speed: const Duration(milliseconds: 80),
              curve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isSmallScreen, double width) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        _buildAnimatedButton(
          isSmallScreen: isSmallScreen,
          width: isSmallScreen ? 140 : 160,
          text: "GitHub",
          icon: Icon(Icons.code),
          onPressed: () {
            AppFunction.launch(Constants.gitHubLink);
          },
        ),
        SizedBox(width: 5),
        _buildAnimatedButton(
          isSmallScreen: isSmallScreen,
          width: isSmallScreen ? 200 : 220,
          text: "Download CV",
          icon: Icon(Icons.download),
          onPressed: () {
            AppFunction.launch(
              Constants.myCVLink,
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedButton({
    required bool isSmallScreen,
    required double width,
    required String text,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(scale: 1.0 + value * 0.1, child: child);
        },
        child: ButtonWidget(
          decorationColor: Colors.transparent,
          width: width,
          color: Colors.transparent,
          buttonBorder: BorderSide(color: AppColors.burbleColor, width: 2),
          text: text,
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 14 : 16,
            horizontal: isSmallScreen ? 16 : 20,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildAnimatedDivider() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 2000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return SizedBox(
          width: 200 * value,
          child: Divider(color: AppColors.burbleColor, height: 2, thickness: 2),
        );
      },
    );
  }
}
