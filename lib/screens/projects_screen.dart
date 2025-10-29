import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constant.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/core/widgets/button.dart';

import '../core/function/app_functions.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
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
                    ? 20
                    : 80,
            vertical: 80,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF000021),
                AppColors.burbleColor.withValues(alpha: 0.05),
                Color(0xFF000021),
              ],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildSectionTitle('My Projects', isMobile),
                const SizedBox(height: 50),
                _buildProjectsGrid(isMobile, isTablet),
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
          'Here are some of my recent works',
          style: TextStyle(fontSize: isMobile ? 16 : 18, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildProjectsGrid(bool isMobile, bool isTablet) {
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
        childAspectRatio: isMobile ? 1.2 : 0.9,
      ),
      itemCount: Constants.projects.length,
      itemBuilder: (context, index) {
        return _buildProjectCard(Constants.projects[index], index, isMobile);
      },
    );
  }

  Widget _buildProjectCard(Project project, int index, bool isMobile) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isSmallMobile = constraints.maxWidth < 400;
              final bool isMediumMobile = constraints.maxWidth < 500;

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallMobile ? 12 : 15,
                  vertical: isSmallMobile ? 12 : 15,
                ),
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
                    // Project Image
                    Container(
                      height:
                          isSmallMobile
                              ? 100
                              : isMediumMobile
                              ? 130
                              : 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.burbleColor.withValues(alpha: 0.1),
                        image: DecorationImage(
                          image: AssetImage(
                            project.image ?? 'assets/placeholder.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Project Name
                    Text(
                      project.name,
                      style: TextStyle(
                        fontSize:
                            isSmallMobile
                                ? 16
                                : isMediumMobile
                                ? 17
                                : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Project Description
                    Expanded(
                      child: Text(
                        project.description,
                        style: TextStyle(
                          fontSize:
                              isSmallMobile
                                  ? 11
                                  : isMediumMobile
                                  ? 12
                                  : 15,
                          color: Colors.white70,
                          // height: 1.4,
                        ),
                        maxLines: isSmallMobile ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Technologies
                    Wrap(
                      spacing: isSmallMobile ? 6 : 8,
                      runSpacing: isSmallMobile ? 4 : 6,
                      children:
                          project.technologies.map((tech) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallMobile ? 6 : 8,
                                vertical: isSmallMobile ? 3 : 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.burbleColor.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.burbleColor.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                tech,
                                style: TextStyle(
                                  fontSize: isSmallMobile ? 9 : 10,
                                  color: AppColors.burbleColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            height: isSmallMobile ? 35 : 40,
                            color: Colors.transparent,
                            buttonBorder: BorderSide(
                              color: AppColors.burbleColor,
                              width: 1,
                            ),
                            text: "GitHub",
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallMobile ? 8 : 12,
                            ),
                            fontSize: isSmallMobile ? 12 : 14,
                            onPressed:
                                () => AppFunction.launch(project.githubUrl),
                          ),
                        ),
                        SizedBox(width: isSmallMobile ? 8 : 10),
                        if (project.liveUrl != null)
                          Expanded(
                            child: ButtonWidget(
                              height: isSmallMobile ? 35 : 40,
                              color: AppColors.burbleColor.withValues(
                                alpha: 0.2,
                              ),
                              buttonBorder: BorderSide(
                                color: AppColors.burbleColor,
                                width: 1,
                              ),
                              text: "Live Demo",
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallMobile ? 8 : 12,
                              ),
                              fontSize: isSmallMobile ? 12 : 14,
                              onPressed:
                                  () => AppFunction.launch(
                                    project.liveUrl ?? project.githubUrl,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Project {
  final String name;
  final String description;
  final List<String> technologies;
  final String? image;
  final String githubUrl;
  final String? liveUrl;

  Project({
    required this.name,
    required this.description,
    required this.technologies,
    this.image,
    required this.githubUrl,
    this.liveUrl,
  });
}
