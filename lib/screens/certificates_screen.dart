import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/core/widgets/button.dart';

import '../core/constant.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
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
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFF000021),
                AppColors.burbleColor.withValues(alpha: 0.08),
                Color(0xFF000021),
              ],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildSectionTitle('Certificates', isMobile),
                const SizedBox(height: 50),
                _buildCertificatesGrid(isMobile, isTablet),
              ],
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
        const SizedBox(height: 16),
        Text(
          'My learning journey and achievements',
          style: TextStyle(fontSize: isMobile ? 16 : 18, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildCertificatesGrid(bool isMobile, bool isTablet) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            isMobile
                ? 1
                : isTablet
                ? 2
                : 3,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: isMobile ? 1.1 : 0.85,
      ),
      itemCount: Constants.certificates.length,
      itemBuilder: (context, index) {
        return _buildCertificateCard(
          Constants.certificates[index],
          index,
          isMobile,
        );
      },
    );
  }

  Widget _buildCertificateCard(
    Certificate certificate,
    int index,
    bool isMobile,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: Card(
          elevation: 8,
          color: Colors.white.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: AppColors.burbleColor.withValues(alpha: 0.3),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.02),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Certificate Image
                Container(
                  height: isMobile ? 120 : 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.burbleColor.withValues(alpha: 0.1),
                    image: DecorationImage(
                      image: AssetImage(certificate.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Certificate Name
                Text(
                  certificate.name,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Issuer and Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      certificate.issuer,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.burbleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      certificate.date,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Skills
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      certificate.skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.burbleColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.burbleColor,
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const Spacer(),
                // View Button
                SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    height: 40,
                    color: Colors.transparent,
                    buttonBorder: BorderSide(
                      color: AppColors.burbleColor,
                      width: 1,
                    ),
                    text: "View Certificate",
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    onPressed: () {
                      _showCertificateDialog(certificate);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCertificateDialog(Certificate certificate) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF000021),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.burbleColor),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    certificate.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 300,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(certificate.image),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonWidget(
                    width: 150,
                    color: AppColors.burbleColor.withValues(alpha: 0.2),
                    buttonBorder: BorderSide(
                      color: AppColors.burbleColor,
                      width: 1,
                    ),
                    text: "Close",
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

class Certificate {
  final String name;
  final String issuer;
  final String date;
  final String image;
  final List<String> skills;

  Certificate({
    required this.name,
    required this.issuer,
    required this.date,
    required this.image,
    required this.skills,
  });
}
