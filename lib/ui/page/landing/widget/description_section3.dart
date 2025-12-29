import 'package:flutter/material.dart';
import 'landing_section_layout.dart';

class Description3 extends StatelessWidget {
  const Description3({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;

    return LandingSectionLayout(
      height: isSmallScreen ? 1500 : 750,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          Text(
            "가장 치명적인 3가지 리스크 해결",
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            isSmallScreen
                ? "공동창업팀이 겪는 현실적인 고민들,\n이제 CoSync가 해결해 드립니다."
                : "공동창업팀이 겪는 현실적인 고민들, 이제 CoSync가 해결해 드립니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: isSmallScreen ? _buildCardsColumn() : _buildCardsRow(),
            ),
          ),
        ],
      ),
    );
  }

  // 가로 배치 (1024px 초과)
  Widget _buildCardsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildCostCard()),
          const SizedBox(width: 24),
          Expanded(child: _buildInvestmentCard()),
          const SizedBox(width: 24),
          Expanded(child: _buildEmotionCard()),
        ],
      ),
    );
  }

  // 세로 배치 (1024px 이하)
  Widget _buildCardsColumn() {
    return Column(
      children: [
        _buildCostCard(),
        const SizedBox(height: 24),
        _buildInvestmentCard(),
        const SizedBox(height: 24),
        _buildEmotionCard(),
      ],
    );
  }

  // 비용 절감 카드
  Widget _buildCostCard() {
    return _RiskHoverCard(
      borderColor: Colors.grey.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.savings_outlined,
                  size: 28,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                '비용 절감',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF15803D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            '주주간 계약서, 전문가에게 바로 맡기면 평균 300만원입니다.',
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'CoSync 연 구독',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const TextSpan(text: '으로 쟁점을 정리하면 비용이 획기적으로 줍니다.'),
              ],
            ),
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '법무비 절감 효과',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              Text(
                '-90%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.9,
              backgroundColor: Colors.green[100],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[400]!),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  // 투자 대비 카드
  Widget _buildInvestmentCard() {
    return _RiskHoverCard(
      borderColor: Colors.grey.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  size: 28,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                '투자 대비',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '투자 심사(Due Diligence)에서 '),
                TextSpan(
                  text: '지분 리스크는 탈락 1순위',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
                const TextSpan(text: '입니다. 필수 항목을 미리 점검하세요.'),
              ],
            ),
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const Spacer(),
          const SizedBox(height: 32),
          _buildCheckItem(Colors.blue[400]!, '주주명부(Cap Table)'),
          const SizedBox(height: 12),
          _buildCheckItem(Colors.blue[400]!, 'IP 양도 계약'),
          const SizedBox(height: 12),
          _buildCheckItem(Colors.blue[400]!, '이탈 방지(Vesting)'),
        ],
      ),
    );
  }

  // 감정 보호 카드
  Widget _buildEmotionCard() {
    return _RiskHoverCard(
      borderColor: Colors.grey.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.handshake_outlined,
                  size: 28,
                  color: const Color(0xFF7E22CE),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                '감정 보호',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7E22CE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '껄끄러운 돈 이야기, '),
                TextSpan(
                  text: '"데이터가 그렇다는데?"',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
                const TextSpan(text: '라고 핑계 대세요. 악역은 시스템이 맡겠습니다.'),
              ],
            ),
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.purple[100]!.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '의사결정 갈등 발생 시',
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'CoSync 해결',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '"CEO에게 최종 결정권 부여"',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(Color color, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: color, size: 14),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class _RiskHoverCard extends StatefulWidget {
  final Widget child;
  final Color borderColor;

  const _RiskHoverCard({required this.child, required this.borderColor});

  @override
  State<_RiskHoverCard> createState() => _RiskHoverCardState();
}

class _RiskHoverCardState extends State<_RiskHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(32),
        height: 380,
        constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
        transform: _isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.0),
              blurRadius: _isHovered ? 28 : 0,
              offset: Offset(0, _isHovered ? 15 : 0),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
