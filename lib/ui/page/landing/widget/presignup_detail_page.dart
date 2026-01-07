import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart' as main_app;
import 'package:flutter_demo/ui/page/landing/widget/email_signup_modal.dart';

class PreSignupDetailPage extends StatelessWidget {
  const PreSignupDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallMobile = screenWidth <= 480;
    final isMobileScreen = screenWidth <= 763;

    // 페이지 진입 이벤트 트래킹
    WidgetsBinding.instance.addPostFrameCallback((_) {
      main_app.MyApp.analytics.logEvent(name: 'presignup_detail_view');
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '베타 출시 알림 신청',
          style: TextStyle(
            fontSize: isSmallMobile ? 18 : 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallMobile ? 20 : isMobileScreen ? 40 : 120,
            vertical: isSmallMobile ? 32 : 48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Text(
                'CoSync 베타 출시를\n가장 먼저 경험하세요',
                style: TextStyle(
                  fontSize: isSmallMobile ? 24 : isMobileScreen ? 32 : 40,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                  height: 1.2,
                ),
              ),
              SizedBox(height: isSmallMobile ? 24 : 32),
              // 서브 타이틀
              Text(
                '공동창업 팀을 위한 합의서 생성 도구',
                style: TextStyle(
                  fontSize: isSmallMobile ? 16 : 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: isSmallMobile ? 32 : 48),
              // 혜택 섹션
              _buildSectionTitle('사전 신청 혜택', isSmallMobile),
              SizedBox(height: isSmallMobile ? 16 : 24),
              _buildBenefitCard(
                '출시 즉시 우선 안내',
                '베타 출시 시 가장 먼저 이메일로 알려드립니다.',
                Icons.notifications_active,
                isSmallMobile,
              ),
              SizedBox(height: isSmallMobile ? 12 : 16),
              _buildBenefitCard(
                '사전 신청자 전용 30% 할인 쿠폰',
                '런칭 후 첫 결제 시 30% 할인 쿠폰을 제공합니다.',
                Icons.local_offer,
                isSmallMobile,
              ),
              SizedBox(height: isSmallMobile ? 12 : 16),
              _buildBenefitCard(
                'Pro 질문 일부 무료 체험',
                'Pro 질문을 일부 무료로 체험하실 수 있습니다.',
                Icons.star,
                isSmallMobile,
              ),
              SizedBox(height: isSmallMobile ? 40 : 56),
              // 서비스 소개
              _buildSectionTitle('CoSync란?', isSmallMobile),
              SizedBox(height: isSmallMobile ? 16 : 24),
              Text(
                'CoSync는 공동창업 팀이 지분, 역할, 이탈 조건 등 핵심 사항을 체계적으로 합의할 수 있도록 도와주는 도구입니다.\n\n'
                '10개 이상의 핵심 질문을 통해 팀원 간 의견 차이를 파악하고, 시장 표준 데이터를 반영한 맞춤형 합의서 초안을 생성해드립니다.',
                style: TextStyle(
                  fontSize: isSmallMobile ? 14 : 16,
                  height: 1.6,
                  color: const Color(0xFF475569),
                ),
              ),
              SizedBox(height: isSmallMobile ? 40 : 56),
              // CTA 버튼
              SizedBox(
                width: double.infinity,
                height: isSmallMobile ? 56 : 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => const EmailSignupModal(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '베타 출시 알림 신청하기',
                        style: TextStyle(
                          fontSize: isSmallMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isSmallMobile ? 24 : 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isSmallMobile) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isSmallMobile ? 20 : 24,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildBenefitCard(
    String title,
    String description,
    IconData icon,
    bool isSmallMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF16A34A),
            size: isSmallMobile ? 24 : 28,
          ),
          SizedBox(width: isSmallMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallMobile ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: isSmallMobile ? 4 : 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isSmallMobile ? 13 : 14,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

