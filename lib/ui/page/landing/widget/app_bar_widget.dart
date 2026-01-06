import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallMobile = screenWidth <= 480;

    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.3),
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 65,
      title: Row(
        children: [
          Image.asset(
            'assets/CoSync.webp',
            height: isSmallMobile ? 24 : 28,
          ),
          const SizedBox(width: 8),
          Text(
            "CoSync",
            style: TextStyle(
              fontSize: isSmallMobile ? 18 : 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF334155),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey[300], height: 1.0),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66);
}
