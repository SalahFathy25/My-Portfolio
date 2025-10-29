import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class Header extends StatefulWidget {
  final Function(String) onNavItemSelected;
  final int currentIndex;
  const Header({
    super.key,
    required this.onNavItemSelected,
    required this.currentIndex,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<String> navItems = [
    'Home',
    'About',
    'Projects',
    'Certificates',
    'Contact Me',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
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

        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF000021).withValues(alpha: 0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: isMobile ? 16 : 20,
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: isMobile ? _buildMobileHeader() : _buildDesktopHeader(),
          ),
        );
      },
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildLogo(), _buildNavItems()],
    );
  }

  Widget _buildMobileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildLogo(), _buildMobileMenu()],
    );
  }

  Widget _buildLogo() {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.burbleColor.withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Salah',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.burbleColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItems() {
    return Row(
      children: List.generate(navItems.length, (index) {
        final isSelected = widget.currentIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient:
                  isSelected
                      ? LinearGradient(
                        colors: [
                          AppColors.burbleColor.withValues(alpha: 0.2),
                          Colors.purpleAccent.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : null,
              borderRadius: BorderRadius.circular(8),
              border:
                  isSelected
                      ? Border.all(
                        color: AppColors.burbleColor.withValues(alpha: 0.5),
                        width: 1,
                      )
                      : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  widget.onNavItemSelected(navItems[index]);
                },
                borderRadius: BorderRadius.circular(8),
                hoverColor: AppColors.burbleColor.withValues(alpha: 0.1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(
                    navItems[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color:
                          isSelected ? AppColors.burbleColor : Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMobileMenu() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.burbleColor.withValues(alpha: 0.2),
            Colors.purpleAccent.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: AppColors.burbleColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: PopupMenuButton<String>(
        icon: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(
            Icons.menu_rounded,
            color: AppColors.burbleColor,
            size: 24,
          ),
        ),
        onSelected: (value) {
          widget.onNavItemSelected(value);
        },
        offset: const Offset(0, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.burbleColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        itemBuilder: (BuildContext context) {
          return navItems.map((String item) {
            final index = navItems.indexOf(item);
            final isSelected = widget.currentIndex == index;
            return PopupMenuItem<String>(
              value: item,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient:
                      isSelected
                          ? LinearGradient(
                            colors: [
                              AppColors.burbleColor.withValues(alpha: 0.15),
                              Colors.purpleAccent.withValues(alpha: 0.08),
                            ],
                          )
                          : null,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      isSelected
                          ? Border.all(
                            color: AppColors.burbleColor.withValues(alpha: 0.3),
                            width: 1,
                          )
                          : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                        color:
                            isSelected ? AppColors.burbleColor : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isSelected)
                      Icon(
                        Icons.check_rounded,
                        color: AppColors.burbleColor,
                        size: 18,
                      ),
                  ],
                ),
              ),
            );
          }).toList();
        },
        color: Colors.white,
      ),
    );
  }
}
