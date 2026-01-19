import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../router/routes.dart';
import '../../../data/model/session.dart';
import 'dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    // Colors
    const Color primaryColor = Color(0xFF137FEC);
    const Color backgroundLight = Color(0xFFF6F7F8);
    // const Color surfaceLight = Colors.white;
    const Color textDark = Color(0xFF191F28);

    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
        children: [
          Column(
            children: [
              // Sticky Header (Simulated with just a container at top of column for now,
              // or use CustomScrollView with SliverAppBar if actual sticky behavior is needed.
              // Given the design "sticky top-0", let's use a blurred container on top of body stack
              // but here we can just place it at top of column if we don't need body to scroll BEHIND it transparently yet.
              // Better visual: content scrolls behind header. So Header should be in Stack.
              // Let's make main content a ScrollView).
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 80), // Space for header
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Section
                          const SizedBox(height: 10),
                          Text(
                            '대시보드',
                            style: GoogleFonts.notoSansKr(
                              fontSize: 32, // lg:text-[36px]
                              fontWeight: FontWeight.bold,
                              color: textDark,
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '현재 진행 중인 합의와 완료된 문서를 확인하세요.',
                            style: GoogleFonts.notoSansKr(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Timeline
                          // Active Session Item
                          Obx(() {
                            final activeSession = controller.activeSession;
                            if (activeSession != null) {
                              return _buildTimelineItem(
                                isLast: false,
                                icon: Icons.pending_actions,
                                iconBgColor: primaryColor,
                                iconColor: Colors.white,
                                badgeText: 'ONGOING',
                                badgeColor: primaryColor,
                                dateText: '현재 진행 중',
                                child: _buildActiveSessionCard(activeSession),
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          // Completed Documents
                          Obx(() {
                            // If we have documents, show them. For now showing Latest.
                            // If user wants full list, we might map them.
                            // Design shows "Final Report v1".
                            // Let's show latest document if exists.
                            final latestDoc = controller.latestDocument.value;
                            if (latestDoc != null) {
                              return _buildTimelineItem(
                                isLast: false,
                                icon: Icons.description_outlined,
                                iconBgColor: Colors.grey.shade100,
                                iconColor: Colors.grey.shade500,
                                badgeText: 'COMPLETED',
                                badgeColor: Colors.grey.shade500,
                                badgeBgColor: Colors.grey.shade100,
                                dateText: '2023년 10월 24일', // TODO: Format date
                                child: _buildCompletedDocCard(latestDoc),
                              );
                            } else {
                              // Static "Completed" item from design if no docs yet?
                              // Or maybe just skip.
                              // Let's show the static example from design if no actual data,
                              // OR better, show empty state or nothing.
                              // For fidelity to design request "UI는 아래 코드와 거의 그대로 유지",
                              // I will implement the layout structure.
                              // If no docs, maybe I shouldn't show the card.
                              // But let's assume we show at least the "Workspace Created" start item next.
                              return const SizedBox.shrink();
                            }
                          }),

                          // Start Item (Workspace Created)
                          _buildTimelineItem(
                            isLast: true,
                            icon: Icons.flag_outlined,
                            iconBgColor: Colors.grey.shade100,
                            iconColor: Colors.grey.shade400,
                            content: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                '팀 워크스페이스가 생성되었습니다.',
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),

                          // Bottom Spacer to avoid FAB overlap
                          const SizedBox(height: 128),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Sticky Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: backgroundLight.withValues(alpha: 0.8),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.transparent,
                      ), // or slight divider
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ), // lg:px-10
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 1200,
                      ), // Max width for header content if needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left: Team Info
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.groups_outlined,
                                  color: primaryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Obx(
                                () => Text(
                                  '팀: ${controller.company.value?.name ?? 'Loading...'}',
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Right: Actions
                          Row(
                            children: [
                              // Team Code Button (Desktop/Tablet)
                              // Hidden on small mobile in HTML "hidden sm:flex"
                              // We can simulate with LayoutBuilder or just display for now
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: controller.copyInviteCode,
                                  borderRadius: BorderRadius.circular(999),
                                  child: Row(
                                    children: [
                                      Text(
                                        '팀 코드: ',
                                        style: GoogleFonts.notoSansKr(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          '#${controller.companyKey.value}',
                                          style: GoogleFonts.notoSansKr(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textDark,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.content_copy_outlined,
                                        size: 16,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Settings Button
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.settings_outlined,
                                    size: 20,
                                  ),
                                  color: textDark,
                                  onPressed: () {
                                    // Navigate to Settings
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating Action Button (Bottom Center)
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Container(
                  height: 56, // h-14
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: textDark.withValues(
                          alpha: 0.3,
                        ), // Shadow approximation
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.sessionCreate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textDark, // #191f28
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          '새로운 합의 세션 만들기',
                          style: GoogleFonts.notoSansKr(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Timeline Builder Methods ---

  Widget _buildTimelineItem({
    required bool isLast,
    IconData? icon,
    Color? iconBgColor,
    Color? iconColor,
    String? badgeText,
    Color? badgeColor,
    Color? badgeBgColor,
    String? dateText,
    Widget? child,
    Widget? content, // Alternative if not using child card pattern
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line & Icon
          SizedBox(
            width: 48 + 24, // Icon width + spacing
            child: Stack(
              children: [
                // Line
                if (!isLast)
                  Positioned(
                    top: 48,
                    bottom: 0,
                    left: 24 - 1, // center of 48 is 24. width 2.
                    child: Container(width: 2, color: const Color(0xFFE2E8F0)),
                  ),
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                    border: isLast
                        ? null
                        : null, // Last item in HTML example has border-4 for bg color match, here we can simplify
                    boxShadow: iconBgColor == const Color(0xFF137FEC)
                        ? [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child:
                content ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (Badge + Date)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                badgeBgColor ??
                                badgeColor?.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badgeText ?? '',
                            style: GoogleFonts.inter(
                              // Robot/Inter for uppercase English
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: badgeColor,
                              letterSpacing: 0.5, // wider tracking
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          dateText ?? '',
                          style: GoogleFonts.notoSansKr(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Card
                    if (child != null) ...[
                      child,
                      const SizedBox(height: 40), // Gap to next item
                    ],
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard(Session session) {
    const Color primaryColor = Color(0xFF137FEC);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Blob decoration
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '지분 분배 세션', // Static title as per design for now, or use session data
                          style: GoogleFonts.notoSansKr(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF191F28),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '현재 단계: 구성원 동의 대기 중', // Placeholder status
                          style: GoogleFonts.notoSansKr(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '합의 진행 중',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.sessionHomePath(session.sessionId));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.blue.withValues(alpha: 0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '세션 바로가기',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
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

  Widget _buildCompletedDocCard(dynamic doc) {
    // using dynamic for doc placeholder standardisation
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        // border: Border.all(color: Colors.transparent), // HTML says border-transparent but hover effect?
        // Let's stick to clean white with shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '최종 합의 리포트 v1', // Placeholder
                    style: GoogleFonts.notoSansKr(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF191F28),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '2023년 10월 24일 생성됨',
                    style: GoogleFonts.notoSansKr(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '완료됨',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Routes.docViewPath(doc.id)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: const Color(0xFF191F28),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.visibility_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  '문서 보기',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
