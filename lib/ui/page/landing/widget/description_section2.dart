import 'package:flutter/material.dart';
import 'landing_section_layout.dart';

class Description2 extends StatelessWidget {
  const Description2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;

    return LandingSectionLayout(
      height: isSmallScreen ? 1100 : 750,
      backgroundColor: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: isSmallScreen ? 24 : 32,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
              children: [
                const TextSpan(text: '계약서를 안 써서 아낀 '),
                const TextSpan(
                  text: '500만 원',
                  style: TextStyle(color: Color(0xFF1D4ED8)),
                ),
                const TextSpan(text: ',\n그 대가는 얼마일까요?'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Text(
            "많은 팀이 비용을 아끼려다 더 큰 기회를 놓치고 있습니다.",
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w900,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 38),
          // 카드 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: isSmallScreen
                ? _buildVerticalLayout()
                : _buildHorizontalLayout(),
          ),
        ],
      ),
    );
  }

  // 세로 배치 (1024px 이하)
  Widget _buildVerticalLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHiddenCostCard(),
        const SizedBox(height: 40),
        _buildCoSyncEffectCard(),
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
            child: _buildHiddenCostCard(),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildCoSyncEffectCard(),
          ),
        ),
      ],
    );
  }

  // 왼쪽 카드: Hidden Cost
  Widget _buildHiddenCostCard() {
    return Container(
      constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
      height: 370,
      padding: const EdgeInsets.all(40),
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
              const Text(
                '숨겨진 비용 (Hidden Cost)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE11D48),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildHiddenCostItem(
            icon: Icons.hourglass_empty_rounded,
            title: '의사결정 지연',
            subtitle: '평균 3~6개월 성장 정체',
          ),
          const SizedBox(height: 24),
          _buildHiddenCostItem(
            icon: Icons.cancel_outlined,
            title: '투자 미팅 종료 (Deal Breaker)',
            subtitle: '합의 구조 불명확 시 탈락',
          ),
          const SizedBox(height: 24),
          _buildHiddenCostItem(
            icon: Icons.payments_outlined,
            title: '법적 분쟁 비용',
            subtitle: '수천만 원 ~ 수억 원 소모',
          ),
        ],
      ),
    );
  }

  // 오른쪽 카드: CoSync Effect
  Widget _buildCoSyncEffectCard() {
    return Container(
      constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
      height: 370,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(32),
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
                  color: Color(0xFF60A5FA),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'CoSync 도입 효과',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
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
                      ),
                      const VerticalDivider(
                        color: Colors.white12,
                        indent: 10,
                        endIndent: 10,
                      ),
                      _buildEffectSection('AFTER', 'Rulebook 12p', '핵심 조항 명문화'),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                Expanded(
                  child: Row(
                    children: [
                      _buildEffectSection(
                        'BEFORE',
                        '위험 감지 불가',
                        '막연한 불안감',
                        isBefore: true,
                      ),
                      const VerticalDivider(
                        color: Colors.white12,
                        indent: 10,
                        endIndent: 10,
                      ),
                      _buildEffectSection('AFTER', '안정성 78점', '데이터 기반 확신'),
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
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.red[400], size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
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
                color: isBefore ? Colors.grey[500] : const Color(0xFF60A5FA),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isBefore ? Colors.grey[400] : Colors.white,
                decoration: strikethrough ? TextDecoration.lineThrough : null,
                decorationColor: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isBefore ? Colors.grey[500] : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
