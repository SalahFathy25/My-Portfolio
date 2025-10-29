import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/core/widgets/button.dart';

import '../core/constant.dart';
import '../core/function/app_functions.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF000021), Colors.black],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Copyright
          Text(
            '© 2025 ${Constants.myName}. All rights reserved.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            'Built with Flutter 💙',
            style: TextStyle(color: AppColors.burbleColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
