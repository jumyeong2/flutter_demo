import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/agreement_item.dart';
import '../../widgets/responsive_layout.dart';
import 'agreement_controller.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Put controller
    final controller = Get.put(AgreementController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(onPressed: () => Get.back()),
        title: const Text("Rulebook"),
      ),
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
                    _buildHeader(context, controller),
                    const SizedBox(height: 32),
                    Obx(
                      () => Column(
                        children: controller.items
                            .map(
                              (item) =>
                                  _buildItemCard(context, controller, item),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildFooterAction(controller),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => controller.showFinalModal.value
                ? _buildFinalModal(context, controller)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AgreementController controller) {
    bool isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.edit_document,
                      color: Colors.indigo,
                      size: 28, // Reduced size for mobile
                    ),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Progress",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                          Text(
                            "${controller.progress.round()}%",
                            style: const TextStyle(
                              fontSize: 20, // Reduced font size
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "공동창업자 주주 간 계약(SHA) 조율",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "스타트업의 안전한 항해를 위해 민감한 주제(지분, 이탈 등)를 미리 합의하고 기록합니다.",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                      ), // Slightly smaller
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(
                  () => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: controller.progress / 100,
                      backgroundColor: Colors.grey[100],
                      color: Colors.indigo,
                      minHeight: 6, // Thinner bar
                    ),
                  ),
                ),
              ],
            )
          : Column(
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
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Column(
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
                            "${controller.progress.round()}%",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(
                  () => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: controller.progress / 100,
                      backgroundColor: Colors.grey[100],
                      color: Colors.indigo,
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    AgreementController controller,
    AgreementItem item,
  ) {
    bool isConflict = item.status == "conflict";
    bool isMobile = ResponsiveLayout.isMobile(context);

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
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
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
            padding: EdgeInsets.all(isMobile ? 16 : 24),
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
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
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
                isMobile
                    ? Column(
                        children: [
                          _opinionBox(
                            "User A (나)",
                            item.userA,
                            (val) => controller.handleUserAChange(item.id, val),
                            item.status == "resolved",
                            isUserA: true,
                          ),
                          const SizedBox(height: 16),
                          _opinionBox(
                            "User B (공동창업자)",
                            item.userB,
                            null,
                            true, // Always disabled for User B in this demo
                            isUserA: false,
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _opinionBox(
                              "User A (나)",
                              item.userA,
                              (val) =>
                                  controller.handleUserAChange(item.id, val),
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
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
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
                              if (!isMobile) // Mobile hides this here, maybe show elsewhere or simplify
                                OutlinedButton.icon(
                                  onPressed: item.isAiLoading
                                      ? null
                                      : () => controller.triggerAI(item.id),
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
                                    side: BorderSide(
                                      color: Colors.indigo[200]!,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                      // AI Button for Mobile (Stacked)
                      if (isConflict && isMobile)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: item.isAiLoading
                                  ? null
                                  : () => controller.triggerAI(item.id),
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Input & Action
                      Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isMobile
                              ? SizedBox(
                                  width: double.infinity,
                                  child: TextField(
                                    controller:
                                        TextEditingController(
                                            text: item.consensus,
                                          )
                                          ..selection =
                                              TextSelection.fromPosition(
                                                TextPosition(
                                                  offset: item.consensus.length,
                                                ),
                                              ),
                                    onChanged: (val) => controller
                                        .handleConsensusChange(item.id, val),
                                    enabled: item.status != "resolved",
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: isConflict
                                          ? "양측의 의견을 조율하여 최종 계약 문구를 작성하세요."
                                          : "",
                                      filled: true,
                                      fillColor: item.status == "resolved"
                                          ? Colors.transparent
                                          : Colors.white,
                                      border: item.status == "resolved"
                                          ? InputBorder.none
                                          : OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                )
                              : Expanded(
                                  child: TextField(
                                    controller:
                                        TextEditingController(
                                            text: item.consensus,
                                          )
                                          ..selection =
                                              TextSelection.fromPosition(
                                                TextPosition(
                                                  offset: item.consensus.length,
                                                ),
                                              ),
                                    onChanged: (val) => controller
                                        .handleConsensusChange(item.id, val),
                                    enabled: item.status != "resolved",
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: isConflict
                                          ? "양측의 의견을 조율하여 최종 계약 문구를 작성하세요."
                                          : "",
                                      filled: true,
                                      fillColor: item.status == "resolved"
                                          ? Colors.transparent
                                          : Colors.white,
                                      border: item.status == "resolved"
                                          ? InputBorder.none
                                          : OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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

                          if (!isMobile) const SizedBox(width: 16),
                          if (isMobile) const SizedBox(height: 16),

                          SizedBox(
                            width: isMobile ? double.infinity : null,
                            height: isMobile ? 50 : 100,
                            child: item.status == "conflict"
                                ? ElevatedButton(
                                    onPressed: () =>
                                        controller.markAsResolved(item.id),
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
                                    child: isMobile
                                        ? const Text(
                                            "조항 확정",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const Column(
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
                                      item.status = "conflict";
                                      controller.handleUserAChange(
                                        item.id,
                                        item.userA,
                                      );
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
                                    child: isMobile
                                        ? const Text(
                                            "수정 하기",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const Column(
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
                              Expanded(
                                child: Text(
                                  "이 내용은 최종 계약서의 ${item.id}조 항으로 반영됩니다.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.indigo[600],
                                    fontWeight: FontWeight.w500,
                                  ),
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
    // Only text selection change logic inside TextField needs care, but for brevity/cleanliness
    // we just return the widget. The layout is handled by parent.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUserA
            ? Colors.indigo[50]!.withValues(alpha: 0.5)
            : Colors.amber[50]!.withValues(alpha: 0.3),
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

  Widget _buildFooterAction(AgreementController controller) {
    return Obx(() {
      bool isComplete = controller.progress >= 100;
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: isComplete
              ? () => controller.showFinalModal.value = true
              : null,
          icon: isComplete
              ? const Icon(Icons.edit_document)
              : const SizedBox.shrink(),
          label: Text(
            isComplete
                ? "합의서(Term Sheet) 생성"
                : "조항이 모두 확정되지 않았습니다 (${controller.progress.round()}%)",
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[300],
            disabledForegroundColor: Colors.grey[500],
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFinalModal(
    BuildContext context,
    AgreementController controller,
  ) {
    bool isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: isMobile ? MediaQuery.of(context).size.width * 0.9 : 600,
          margin: const EdgeInsets.all(24),
          padding: EdgeInsets.all(isMobile ? 24 : 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
              ),
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
              Obx(() {
                if (!controller.emailSent.value) {
                  return Container(
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
                            Icon(
                              Icons.description,
                              size: 20,
                              color: Colors.grey,
                            ),
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
                                onChanged: (val) =>
                                    controller.email.value = val,
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
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: controller.handleSendEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F172A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("발송"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${controller.email.value}로\n합의서가 발송되었습니다.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      OutlinedButton(
                        onPressed: () =>
                            controller.showFinalModal.value = false,
                        child: const Text("닫기"),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String category) {
    if (category.contains("R&R")) return Icons.people_outline;
    if (category.contains("지분") || category.contains("베스팅")) {
      return Icons.pie_chart_outline;
    }
    if (category.contains("이탈")) return Icons.exit_to_app;
    return Icons.article_outlined;
  }
}
