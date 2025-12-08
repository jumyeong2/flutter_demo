import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'landing_controller.dart';
import '../../widgets/responsive_layout.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LandingController());

    final List<Map<String, dynamic>> demoSteps = [
      {
        "title": "1단계: 심층 진단 (Deep Dive)",
        "desc": "가장 민감한 '이탈 조건'에 대해 각자의 솔직한 생각을 입력합니다.",
        "content": _DemoStep1(),
      },
      {
        "title": "2단계: 리스크 시각화 (Risk Radar)",
        "desc": "답변 데이터를 분석하여 조율이 필요한 부분을 시각화합니다.",
        "content": _DemoStep2(),
      },
      {
        "title": "3단계: AI 중재안 (Solution)",
        "desc": "업계 표준 데이터와 양측의 입장을 고려한 구체적인 절충안을 제시합니다.",
        "content": _DemoStep3(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.blue[100]!.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.indigo[100]!.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main Scroll View
          SingleChildScrollView(
            child: Column(
              children: [
                _buildNavbar(context, controller),
                _buildHeroSection(context, controller),
                _buildProcessSection(),
                _buildDemoSection(context, controller, demoSteps),
                _buildRadarSection(context),
                _buildRulebookSection(context),
                _buildCtaSection(context, controller),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavbar(BuildContext context, LandingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Co-founder Sync",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          if (!ResponsiveLayout.isMobile(context))
            Row(
              children: [
                _navLink("프로세스"),
                _navLink("리스크 진단"),
                _navLink("Rulebook이란?"),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: controller.startTrial,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "팀 Rulebook 만들기",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          else
            Obx(
              () => IconButton(
                icon: Icon(
                  controller.isMenuOpen.value ? Icons.close : Icons.menu,
                ),
                onPressed: controller.toggleMenu,
              ),
            ),
        ],
      ),
    );
  }

  Widget _navLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, LandingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 128, 24, 80),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.yellow[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 16),
                const SizedBox(width: 8),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: "⚡️ 지금 "),
                      TextSpan(
                        text: "12팀",
                        style: TextStyle(color: Colors.blue),
                      ),
                      TextSpan(text: "이 실시간으로 합의 중입니다"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "변호사 없이 끝내는\n가장 완벽한 합의,",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 28 : 40,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            "'팀 Rulebook'",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 28 : 40,
              fontWeight: FontWeight.w800,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "\"우리는 서로 믿으니까 계약서는 나중에?\"",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 16 : 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "아니요, 믿을수록 처음부터 투명해야 합니다.\n감정 소모 없이, 데이터로 합의하세요.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: controller.startTrial,
                icon: const Icon(Icons.chevron_right),
                label: const Text("팀 Rulebook 만들기"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  textStyle: TextStyle(
                    fontSize: ResponsiveLayout.isMobile(context) ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.description, color: Colors.grey),
                label: const Text("샘플 리포트 보기"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF334155),
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProcessSection() {
    final steps = [
      {
        "icon": Icons.chat_bubble_outline,
        "title": "1. 진단 (Sync)",
        "desc": "단순한 설문이 아닙니다. 예민하지만 꼭 필요한 질문에 각자 답변합니다.",
      },
      {
        "icon": Icons.bar_chart,
        "title": "2. 리스크 시각화",
        "desc": "생각이 일치하는 부분과 조율이 필요한 부분을 데이터로 명확히 보여줍니다.",
      },
      {
        "icon": Icons.psychology,
        "title": "3. AI 중재안",
        "desc": "\"이런 방식은 어때요?\" 양쪽의 입장을 고려한 Option A, B, C를 제안합니다.",
      },
      {
        "icon": Icons.description_outlined,
        "title": "4. Rulebook",
        "desc": "합의된 내용을 바탕으로 법적 효력을 고려한 공동창업자 룰북을 생성합니다.",
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            "감정 싸움 없이 합의하는 4단계 프로세스",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "코파운더 싱크는 '중간 다리' 역할을 통해 객관적인 합의를 이끌어냅니다.",
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: steps.map((step) {
                  double width;
                  if (ResponsiveLayout.isMobile(context)) {
                    width = (constraints.maxWidth - 32) / 2;
                  } else if (ResponsiveLayout.isTablet(context)) {
                    width = (constraints.maxWidth - 32) / 2;
                  } else {
                    width = (constraints.maxWidth - 96) / 4;
                  }
                  return Container(
                    width: width,
                    padding: EdgeInsets.all(
                      ResponsiveLayout.isMobile(context) ? 16 : 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[100]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            color: Colors.blue[600],
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          step['title'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          step['desc'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDemoSection(
    BuildContext context,
    LandingController controller,
    List<Map<String, dynamic>> demoSteps,
  ) {
    bool isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      color: Colors.grey[50],
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Column(
        children: [
          const Text(
            "어떻게 합의하는지 미리 보세요",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "30초면 갈등을 예방하는 과정을 체험할 수 있습니다.",
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 48),
          Container(
            constraints: const BoxConstraints(maxWidth: 1024),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                ),
              ],
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[100]!),
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          _circle(Colors.grey[300]!),
                          const SizedBox(width: 8),
                          _circle(Colors.grey[300]!),
                          const SizedBox(width: 8),
                          _circle(Colors.grey[300]!),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        "Team_Rulebook_Generator",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 40),
                  child: Column(
                    children: [
                      // Steps
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _demoStepButton(0, "진단", controller),
                            _demoStepButton(1, "시각화", controller),
                            _demoStepButton(2, "AI중재", controller),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Content
                      Obx(
                        () => Container(
                          padding: EdgeInsets.all(isMobile ? 16 : 24),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[100]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                demoSteps[controller.demoStep.value]['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                demoSteps[controller.demoStep.value]['desc'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 24),
                              demoSteps[controller.demoStep.value]['content']
                                  as Widget,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () {
                          controller.setDemoStep(
                            (controller.demoStep.value + 1) % 3,
                          );
                        },
                        icon: const Icon(Icons.chevron_right, size: 16),
                        label: const Text("다음 단계 미리보기"),
                      ),
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

  Widget _circle(Color color) => Container(
    width: 12,
    height: 12,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  Widget _demoStepButton(
    int index,
    String label,
    LandingController controller,
  ) {
    bool isActive = controller.demoStep.value == index;
    return GestureDetector(
      onTap: () => controller.setDemoStep(index),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? Colors.blue[600] : Colors.grey[100],
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.blue[600] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarSection(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            spacing: 48,
            runSpacing: 48,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Radar Card
              Container(
                width: ResponsiveLayout.isMobile(context)
                    ? double.infinity
                    : 400,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                    ),
                  ],
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.show_chart, size: 64, color: Colors.blue),
                    const SizedBox(height: 24),
                    _riskItem("💰 보상/지분 합의", "안정적 (95점)", Colors.green),
                    const SizedBox(height: 12),
                    _riskItem("🚪 Exit / 이탈 조건", "위험 (32점)", Colors.red),
                    const SizedBox(height: 12),
                    _riskItem("🎯 비전 일치도", "보통 (70점)", Colors.orange),
                  ],
                ),
              ),
              // Text Content
              SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "RISK RADAR",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(text: "팀의 안정성을 점수로 관리하세요.\n"),
                          TextSpan(
                            text: "Team Stability Score",
                            style: TextStyle(color: Colors.grey, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "'그냥 느낌이 좀 쎄한데?'라는 감을 데이터로 확인시켜 드립니다.\n자금, 비전, 역할, 이탈 조건 등 5가지 핵심 영역을 시각화하여 어디서 갈등이 터질지 미리 예측하고 방어합니다.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF475569),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _riskItem(String label, String score, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
          Text(
            score,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildRulebookSection(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            spacing: 64,
            runSpacing: 64,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Text Content
              SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "FINAL OUTPUT",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "말뿐인 약속은 잊혀집니다.\n'공동창업자 Rulebook'으로 기록하세요.",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "동업계약서 쓰기엔 너무 딱딱하고, 말로만 하기엔 불안하신가요?\nCo-founder Sync는 합의된 내용을 바탕으로 우리 팀만의 헌법, [Rulebook.pdf]를 생성해 드립니다.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF475569),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _checkItem("Mission & Vision (우리가 모인 이유)"),
                    _checkItem("R&R (명확한 역할과 책임)"),
                    _checkItem("Compensation (지분 및 급여)"),
                    _checkItem("Decision Making (의사결정 구조)"),
                    _checkItem("Exit Plan (아름다운 이별의 조건)"),
                  ],
                ),
              ),
              // Document Preview
              Transform.rotate(
                angle: -0.05,
                child: Container(
                  width: ResponsiveLayout.isMobile(context)
                      ? double.infinity
                      : 400,
                  height: 500,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Co-founder Rulebook",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Serif',
                                ),
                              ),
                              Text(
                                "Ver 1.0 | 2024.05.20",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.description,
                            color: Colors.grey[300],
                            size: 32,
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _docSection(
                              "Chapter 3. Equity & Vesting",
                              "제3조 (지분 및 베스팅)",
                              "공동창업자 김민준, 이강인은 총 4년의 베스팅 기간을 설정하며...",
                            ),
                            const SizedBox(height: 24),
                            _docSection(
                              "Chapter 5. Exit Plan",
                              "제5조 (이탈 조건)",
                              "자발적 퇴사의 경우 보유 지분의 50%를 액면가로 회사에 반환하며...",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _docSection(String subtitle, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCtaSection(BuildContext context, LandingController controller) {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "건강한 팀만이\n유니콘이 될 수 있습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "지금의 껄끄러움이 나중의 소송을 막습니다.\n가장 합리적인 비용으로 팀의 안전장치를 마련하세요.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 14 : 18,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: controller.startTrial,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("질문 3개로 Rulebook 체험하기 (무료)"),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.psychology, color: Colors.grey[400], size: 20),
              const SizedBox(width: 8),
              const Text(
                "Co-founder Sync",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "© 2024 Co-founder Sync. All rights reserved.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DemoStep1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveLayout.isMobile(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.only(
                      top: 2,
                    ), // Align slightly with text
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Scenario Q.03 (Exit Plan)",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "\"법인 설립 후 1년 이내에 공동창업자가 자발적으로 퇴사한다면, 지분은 어떻게 처리해야 할까요?\"",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _chatBubble("민준 (CEO)", "지분은 전량 반납(Cliff)해야 합니다.", Colors.blue),
              const SizedBox(height: 12),
              _chatBubble(
                "강인 (CTO)",
                "최소한의 개발 기여분(10%)은 인정해줘야 공평하죠.",
                Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chatBubble(String name, String text, MaterialColor color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color[600],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }
}

class _DemoStep2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "합의 준비도",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "45",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    children: [
                      TextSpan(
                        text: "/100",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _barItem("지분 회수(Cliff) 조건", 0.85, Colors.red, "심각한 충돌"),
            const SizedBox(height: 12),
            _barItem("역할 및 보상 (R&R)", 0.9, Colors.blue, "일치함 ✅"),
          ],
        ),
      ),
    );
  }

  Widget _barItem(String label, double percent, Color color, String status) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[100],
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _DemoStep3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _optionCard(
          "Option A. 표준형 (Standard)",
          "1년 미만 퇴사 시 지분 전량 회수. 대신 급여 소급 지급 조항 추가.",
          false,
        ),
        const SizedBox(height: 12),
        _optionCard(
          "Option B. 마일스톤 연동형 (Hybrid)",
          "기본적으로 1년 클리프를 적용하되, MVP 런칭 마일스톤 달성 시 5% 지분 인정.",
          true,
        ),
      ],
    );
  }

  Widget _optionCard(String title, String desc, bool isRecommended) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRecommended ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended ? Colors.blue : Colors.grey[200]!,
        ),
        boxShadow: isRecommended
            ? [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRecommended)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.psychology, size: 14, color: Colors.blue[700]),
                  const SizedBox(width: 4),
                  Text(
                    "AI 추천",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isRecommended ? Colors.blue[900] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              color: isRecommended ? Colors.blue[800] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
