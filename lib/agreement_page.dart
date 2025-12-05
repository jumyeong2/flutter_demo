import 'package:flutter/material.dart';

class AgreementItem {
  final int id;
  final String category;
  final String question;
  final String description;
  String userA;
  final String userB;
  String consensus;
  String status; // "conflict" | "resolved"
  final String aiSuggestion;
  bool isAiLoading;

  AgreementItem({
    required this.id,
    required this.category,
    required this.question,
    required this.description,
    required this.userA,
    required this.userB,
    this.consensus = "",
    this.status = "conflict",
    required this.aiSuggestion,
    this.isAiLoading = false,
  });
}

class AgreementPage extends StatefulWidget {
  const AgreementPage({super.key});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  List<AgreementItem> items = [
    AgreementItem(
      id: 1,
      category: "역할 및 책임 (R&R)",
      question: "각 창업자의 핵심 역할과 의사결정 권한은 어떻게 나눌까요?",
      description: "C-Level 직함과 최종 결정권이 있는 영역을 명확히 해야 합니다.",
      userA:
          "저는 CEO로서 경영, 투자 유치, 제품 기획 총괄을 맡고 싶습니다. 개발 관련 최종 결정권은 CTO에게 위임합니다.",
      userB: "저는 CTO로서 개발 전반을 맡되, 제품 기획 단계에서도 기술적 거부권(Veto)을 갖고 싶습니다.",
      aiSuggestion:
          "시장 표준 R&R: 경영/자금은 CEO 전결(100%), 기술 스택은 CTO 전결(100%). 단, 제품 로드맵은 5:5 합의를 원칙으로 하되, 데드락(Deadlock) 발생 시 CEO가 최종 결정권(Casting Vote)을 행사하는 구조가 일반적입니다.",
    ),
    AgreementItem(
      id: 2,
      category: "베스팅(Vesting) 기간",
      question: "지분을 온전히 자신의 것으로 만드는 데 몆 년이 걸리게 할까요?",
      description: "보통 창업 멤버의 근속을 유도하기 위해 설정합니다. (표준: 3~4년)",
      userA: "서로 믿는 사이니까 별도 기간 없이 바로 100% 인정하면 좋겠습니다.",
      userB: "혹시 모를 이탈을 대비해 4년 베스팅을 적용해야 안전할 것 같습니다.",
      aiSuggestion:
          "VC 투자 표준: 총 4년(48개월) 베스팅. 최초 1년(Cliff) 근무 시 지분의 25%를 일괄 인정하고, 이후 3년간 매월 1/48(약 2.08%)씩 분할 귀속시키는 조건이 가장 보편적입니다.",
    ),
    AgreementItem(
      id: 4,
      category: "이탈 시 지분 처리 (Bad Leaver)",
      question: "고의적 태만이나 배임으로 인한 퇴사 시 지분은 어떻게 할까요?",
      description: "Bad Leaver 발생 시 지분을 액면가로 회수할지 등에 대한 합의입니다.",
      userA: "징계 해고나 배임의 경우라면 액면가로 전량 회수해야 합니다.",
      userB: "동의합니다. 액면가 회수 조항 넣죠.",
      aiSuggestion:
          "표준 계약 조항: Bad Leaver(횡령, 배임 등) 확정 시, 보유 지분 100%를 '액면가'로 강제 회수(Call Option). 단순 변심 등(Good Leaver)의 경우, 근속 기간에 비례해 베스팅된 지분은 인정하되 잔여 지분만 무상 회수합니다.",
    ),
  ];

  bool showFinalModal = false;
  String email = "";
  bool emailSent = false;

  double get progress {
    int resolvedCount = items.where((i) => i.status == "resolved").length;
    return (resolvedCount / items.length) * 100;
  }

  void handleUserAChange(int id, String value) {
    setState(() {
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        items[index].userA = value;
        // Simple logic to check if resolved (in React code it was exact match, keeping it simple here)
        if (value.trim() == items[index].userB.trim()) {
          items[index].status = "resolved";
        } else {
          items[index].status = "conflict";
        }
      }
    });
  }

  void handleConsensusChange(int id, String value) {
    setState(() {
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        items[index].consensus = value;
      }
    });
  }

  void markAsResolved(int id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (items[index].consensus.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("계약 조항으로 들어갈 합의 내용을 입력해주세요.")),
        );
        return;
      }
      setState(() {
        items[index].status = "resolved";
      });
    }
  }

  void triggerAI(int id) {
    setState(() {
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        items[index].isAiLoading = true;
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          final index = items.indexWhere((item) => item.id == id);
          if (index != -1) {
            items[index].consensus = items[index].aiSuggestion;
            items[index].isAiLoading = false;
          }
        });
      }
    });
  }

  void handleSendEmail() {
    if (!email.contains("@")) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("올바른 이메일 주소를 입력해주세요.")));
      return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          emailSent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1024),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    ...items.map((item) => _buildItemCard(item)),
                    const SizedBox(height: 48),
                    _buildFooterAction(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          if (showFinalModal) _buildFinalModal(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.edit_document,
                          color: Colors.indigo,
                          size: 32,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "공동창업자 주주 간 계약(SHA) 조율",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "스타트업의 안전한 항해를 위해 민감한 주제(지분, 이탈 등)를 미리 합의하고 기록합니다.",
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Agreement Progress",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    "${progress.round()}%",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[100],
              color: Colors.indigo,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(AgreementItem item) {
    bool isConflict = item.status == "conflict";
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConflict ? Colors.amber[200]! : Colors.indigo[100]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isConflict ? Colors.amber[100] : Colors.indigo[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isConflict ? Icons.balance : Icons.gavel,
                    size: 12,
                    color: isConflict ? Colors.amber[900] : Colors.indigo[900],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isConflict ? "조율 필요" : "조항 확정",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isConflict
                          ? Colors.amber[900]
                          : Colors.indigo[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Question
                Row(
                  children: [
                    Icon(
                      _getIcon(item.category),
                      size: 20,
                      color: Colors.indigo,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.question,
                  style: const TextStyle(
                    fontSize: 20,
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
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Opinions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _opinionBox(
                        "User A (나)",
                        item.userA,
                        (val) => handleUserAChange(item.id, val),
                        item.status == "resolved",
                        isUserA: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _opinionBox(
                        "User B (공동창업자)",
                        item.userB,
                        null,
                        true, // Always disabled for User B in this demo
                        isUserA: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Consensus Area
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isConflict ? Colors.grey[50] : Colors.indigo[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isConflict
                          ? Colors.grey[200]!
                          : Colors.indigo[200]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (isConflict)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "최종 합의안 (계약 조항)",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: item.isAiLoading
                                    ? null
                                    : () => triggerAI(item.id),
                                icon: item.isAiLoading
                                    ? const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.scale, size: 16),
                                label: Text(
                                  item.isAiLoading
                                      ? "시장 표준 분석 중..."
                                      : "시장 표준(Standard) 제안받기",
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.indigo,
                                  side: BorderSide(color: Colors.indigo[200]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  TextEditingController(text: item.consensus)
                                    ..selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: item.consensus.length,
                                      ),
                                    ),
                              onChanged: (val) =>
                                  handleConsensusChange(item.id, val),
                              enabled: item.status != "resolved",
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: isConflict
                                    ? "양측의 의견을 조율하여 최종 계약 문구를 작성하세요. (AI 제안 활용 가능)"
                                    : "",
                                filled: true,
                                fillColor: item.status == "resolved"
                                    ? Colors.transparent
                                    : Colors.white,
                                border: item.status == "resolved"
                                    ? InputBorder.none
                                    : OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                              ),
                              style: TextStyle(
                                color: item.status == "resolved"
                                    ? Colors.indigo[900]
                                    : Colors.black,
                                fontWeight: item.status == "resolved"
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            height: 100,
                            child: item.status == "conflict"
                                ? ElevatedButton(
                                    onPressed: () => markAsResolved(item.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0F172A),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.gavel),
                                        SizedBox(height: 4),
                                        Text(
                                          "조항\n확정",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        item.status = "conflict";
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.indigo,
                                      side: BorderSide(
                                        color: Colors.indigo[200]!,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "수정\n하기",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      if (item.status == "resolved")
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.indigo[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "이 내용은 최종 계약서의 ${item.id}조 항으로 반영됩니다.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.indigo[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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

  Widget _opinionBox(
    String label,
    String text,
    Function(String)? onChanged,
    bool disabled, {
    required bool isUserA,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUserA
            ? Colors.indigo[50]!.withOpacity(0.5)
            : Colors.amber[50]!.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUserA ? Colors.indigo[100]! : Colors.amber[100]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          disabled
              ? Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF334155),
                    height: 1.5,
                  ),
                )
              : TextField(
                  controller: TextEditingController(text: text)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: text.length),
                    ),
                  onChanged: onChanged,
                  maxLines: 3,
                  decoration: const InputDecoration.collapsed(
                    hintText: "본인의 입장을 작성하세요.",
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF334155),
                    height: 1.5,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFooterAction() {
    bool isComplete = progress >= 100;
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: isComplete
            ? () => setState(() => showFinalModal = true)
            : null,
        icon: isComplete
            ? const Icon(Icons.edit_document)
            : const SizedBox.shrink(),
        label: Text(
          isComplete
              ? "합의서(Term Sheet) 생성"
              : "조항이 모두 확정되지 않았습니다 (${progress.round()}%)",
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildFinalModal() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 600,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.balance,
                  size: 32,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Co-Founder Agreement",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[100]!),
                ),
                child: Text(
                  "\"본 문서는 법적 효력이 없으며, 참고용입니다.\n정식 계약 전에는 반드시 전문 변호사 검토를 받으십시오.\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 32),
              if (!emailSent) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.description, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            "합의서 PDF 받기",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (val) => email = val,
                              decoration: InputDecoration(
                                hintText: "이메일 주소를 입력하세요",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: handleSendEmail,
                            icon: const Icon(Icons.mail),
                            label: const Text("PDF 보내기"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "* 입력하신 이메일로 합의서 초안(PDF)과 변호사 검토 가이드가 발송됩니다.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => showFinalModal = false),
                  child: const Text(
                    "닫기 (저장하지 않음)",
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 24,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "발송 완료!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: "로\n합의서가 성공적으로 전송되었습니다."),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green[700]),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => setState(() {
                          showFinalModal = false;
                          emailSent = false;
                        }),
                        child: const Text(
                          "닫기",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String category) {
    if (category.contains("역할")) return Icons.people;
    if (category.contains("베스팅")) return Icons.access_time;
    if (category.contains("클리프")) return Icons.warning;
    if (category.contains("이탈")) return Icons.shield;
    return Icons.balance;
  }
}
