import 'package:flutter/material.dart';
import 'landing_section_layout.dart';

class Description3 extends StatelessWidget {
  const Description3({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;
    final isSmallMobile = screenWidth <= 480;

    return LandingSectionLayout(
      height: null,
      backgroundColor: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Text.rich(
            TextSpan(
            style: TextStyle(
              fontSize: isSmallMobile ? 20 : (isSmallScreen ? 24 : 32),
              fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
              children: [
                const TextSpan(text: '계약서를 안 써서 아낀 '),
                const TextSpan(
                  text: '300만 원',
                  style: TextStyle(color: Color(0xFF1D4ED8)),
                ),
                TextSpan(text: isSmallMobile ? ',\n그 대가는 얼마일까요?' : ',\n그 대가는 얼마일까요?'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Text(
            "비용을 아끼려다 더 큰 기회를 놓치고 있습니다.",
            style: TextStyle(
              fontSize: isSmallMobile ? 14 : (isSmallScreen ? 16 : 18),
              fontWeight: FontWeight.w900,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallMobile ? 28 : 38),
          // 카드 영역
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallMobile ? 0 : 30.0),
              child: isSmallScreen
                ? _buildVerticalLayout(isSmallMobile)
                : _buildHorizontalLayout(),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // 세로 배치 (1024px 이하)
  Widget _buildVerticalLayout(bool isSmallMobile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHiddenCostCard(isSmallMobile),
        const SizedBox(height: 40),
        _buildCoSyncEffectCard(isSmallMobile),
      ],
    );
  }

  // 가로 배치 (1024px 초과)
  Widget _buildHorizontalLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _buildHiddenCostCard(false),
                ),
              ),
        const SizedBox(width: 40),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildCoSyncEffectCard(false),
                ),
              ),
            ],
    );
  }

  // 왼쪽 카드: Hidden Cost
  Widget _buildHiddenCostCard(bool isSmallMobile) {
    return Container(
      constraints: BoxConstraints(
        minWidth: isSmallMobile ? 0 : 400,
        maxWidth: 500,
      ),
      height: isSmallMobile ? 320 : 370,
      padding: EdgeInsets.all(isSmallMobile ? 20 : 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '숨겨진 비용 (Hidden Cost)',
                style: TextStyle(
                  fontSize: isSmallMobile ? 18 : 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE11D48),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallMobile ? 24 : 40),
          _buildHiddenCostItem(
            icon: Icons.hourglass_empty_rounded,
            title: '의사결정 지연',
            subtitle: '평균 3~6개월 성장 정체',
            isSmallMobile: isSmallMobile,
          ),
          const SizedBox(height: 24),
          _buildHiddenCostItem(
            icon: Icons.cancel_outlined,
            title: '투자 미팅 종료',
            subtitle: '합의 구조 불명확 시 탈락',
            isSmallMobile: isSmallMobile,
          ),
          const SizedBox(height: 24),
          _buildHiddenCostItem(
            icon: Icons.payments_outlined,
            title: '법적 분쟁 비용',
            subtitle: '수천만 원 ~ 수억 원 소모',
            isSmallMobile: isSmallMobile,
          ),
        ],
      ),
    );
  }

  // 오른쪽 카드: CoSync Effect
  Widget _buildCoSyncEffectCard(bool isSmallMobile) {
    return Container(
      constraints: BoxConstraints(
        minWidth: isSmallMobile ? 0 : 400,
        maxWidth: 500,
      ),
      height: isSmallMobile ? 320 : 370,
      padding: EdgeInsets.all(isSmallMobile ? 20 : 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF1D4ED8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'CoSync 도입 효과',
                style: TextStyle(
                  fontSize: isSmallMobile ? 18 : 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallMobile ? 24 : 40),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                  children: [
                      _buildEffectSection(
                        'BEFORE',
                        '문서 0장',
                        '구두 합의만 존재',
                        isBefore: true,
                        strikethrough: true,
                        isSmallMobile: isSmallMobile,
                      ),
                      const VerticalDivider(
                        color: Colors.grey,
                        indent: 10,
                        endIndent: 10,
                        thickness: 0.5,
                      ),
                      _buildEffectSection('AFTER', '10개+ 핵심 질문 진단', '질문 세트 확장 가능', isSmallMobile: isSmallMobile),
                    ],
                  ),
                ),
                const Divider(color: Colors.grey, height: 1, thickness: 0.5),
                Expanded(
                  child: Row(
                    children: [
                      _buildEffectSection(
                        'BEFORE',
                        '위험 감지 불가',
                        '막연한 불안감',
                        isBefore: true,
                        isSmallMobile: isSmallMobile,
                      ),
                      const VerticalDivider(
                        color: Colors.grey,
                        indent: 10,
                        endIndent: 10,
                        thickness: 0.5,
                      ),
                      _buildEffectSection('AFTER', '5개 리스크 항목 점검', '차이점 즉시 시각화', isSmallMobile: isSmallMobile),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHiddenCostItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSmallMobile,
  }) {
    return Row(
      children: [
        Container(
          width: isSmallMobile ? 40 : 48,
          height: isSmallMobile ? 40 : 48,
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.red[400],
            size: isSmallMobile ? 20 : 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Text(
                title,
          style: TextStyle(
                  fontSize: isSmallMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isSmallMobile ? 12 : 14,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEffectSection(
    String label,
    String title,
    String subtitle, {
    bool isBefore = false,
    bool strikethrough = false,
    bool isSmallMobile = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isBefore ? Colors.grey[500] : const Color(0xFF1D4ED8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallMobile ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: isBefore ? Colors.grey[600] : const Color(0xFF1E293B),
                decoration: strikethrough ? TextDecoration.lineThrough : null,
                decorationColor: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isBefore ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

