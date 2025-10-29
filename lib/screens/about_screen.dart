import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constant.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/core/widgets/button.dart';
import 'package:my_portfolio/core/widgets/size_config_helper.dart';

class AboutScreen extends StatefulWidget {
  final VoidCallback onHireMe;
  const AboutScreen({super.key, required this.onHireMe});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

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
        final bool isMobile = constraints.maxWidth < 600;
        final bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1000;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal:
                isMobile
                    ? 20
                    : isTablet
                    ? 40
                    : 80,
            vertical: 80,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF000021),
                AppColors.burbleColor.withValues(alpha: 0.1),
                Color(0xFF000021),
              ],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSectionTitle('About Me', isMobile),
                  const SizedBox(height: 60),
                  _buildContent(isMobile, isTablet),
                  const SizedBox(height: 40),
                  _buildSkillsSection(isMobile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isMobile) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.burbleColor, Colors.purpleAccent],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return Column(
        children: [
          _buildProfileImage(isMobile),
          const SizedBox(height: 40),
          _buildAboutText(isMobile),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildAboutText(isMobile)),
        const SizedBox(width: 60),
        Expanded(flex: 1, child: _buildProfileImage(isMobile)),
      ],
    );
  }

  Widget _buildProfileImage(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.burbleColor.withValues(alpha: 0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          Constants.myImage,
          width: isMobile ? 200 : 300,
          height: isMobile ? 200 : 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAboutText(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Creative Flutter Developer & Instructor',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            color: AppColors.burbleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'I\'m a passionate Flutter developer with expertise in building beautiful, responsive cross-platform applications. With a strong background in Computer Science, I love turning complex problems into simple, beautiful designs.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'When I\'m not coding, you can find me sharing knowledge through Flutter instruction, exploring new technologies, or contributing to open-source projects.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            ButtonWidget(
              width: isMobile ? 140 : 160,
              color: Colors.transparent,
              buttonBorder: BorderSide(color: AppColors.burbleColor, width: 2),
              text: "Hire Me",
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              onPressed: widget.onHireMe,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillsSection(bool isMobile) {
    return Column(
      children: [
        _buildSectionTitle('Skills', isMobile),
        const SizedBox(height: 40),
        Wrap(
          spacing: 30,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children:
              Constants.skills.map((skill) {
                return _buildSkillItem(
                  skill['name'] as String,
                  skill['level'] as double,
                  isMobile,
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSkillItem(String name, double level, bool isMobile) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000 + (level * 500).toInt()),
      tween: Tween(begin: 0.0, end: level),
      builder: (context, value, child) {
        final double containerWidth =
            isMobile ? SizeConfig.screenWidth * 0.4 : 200;
        final double progressWidth = containerWidth * value;

        return Container(
          width: containerWidth,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.burbleColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Stack(
                children: [
                  Container(
                    height: 8,
                    width: containerWidth - 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: progressWidth - 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.burbleColor, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(value * 100).toInt()}%',
                  style: TextStyle(
                    color: AppColors.burbleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
