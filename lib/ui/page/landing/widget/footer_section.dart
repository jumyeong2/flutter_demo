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
          const SizedBox(height: 20),
          // 면책 조항 (간단 버전)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallMobile ? 20 : 40),
            child: Text(
              "본 서비스에서 생성되는 합의 문장은 주주간계약서 또는 동업계약서의 작성을 대체하지 않으며, 해당 계약서에 반영될 수 있는 기초 자료로 활용됩니다.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallMobile ? 11 : 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 카피라이트
          Text(
            "© 2025 CoSync. All rights reserved.",
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
