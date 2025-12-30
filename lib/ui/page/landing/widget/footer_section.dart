import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallMobile = screenWidth <= 480;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isSmallMobile ? 40 : 60),
      color: Colors.white,
      child: Column(
        children: [
          // 로고 및 브랜드명
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/CoSync.webp',
                height: isSmallMobile ? 24 : 28,
                color: const Color(0xFF94A3B8),
                colorBlendMode: BlendMode.srcIn,
              ),
              const SizedBox(width: 8),
              Text(
                "Co-founder Sync",
                style: TextStyle(
                  fontSize: isSmallMobile ? 18 : 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF334155),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 카피라이트
          Text(
            "© 2024 Co-founder Sync. All rights reserved.",
            style: TextStyle(
              fontSize: isSmallMobile ? 12 : 14,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          // 링크 영역
          if (isSmallMobile)
            Column(
              children: [
                _buildFooterLink("서비스 이용약관"),
                const SizedBox(height: 12),
                _buildFooterLink("개인정보 처리방침"),
                const SizedBox(height: 12),
                _buildFooterLink("문의하기"),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFooterLink("서비스 이용약관"),
                _buildDivider(),
                _buildFooterLink("개인정보 처리방침"),
                _buildDivider(),
                _buildFooterLink("문의하기"),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(width: 1, height: 12, color: const Color(0xFFE2E8F0)),
    );
  }
}
