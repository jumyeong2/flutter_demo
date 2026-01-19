import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../router/routes.dart';
import '../../../data/model/session.dart';
import 'dashboard_controller.dart';

/// DashboardPage: 대시보드/세션 리스트 페이지
/// 세션 목록을 표시하고 새 세션을 생성할 수 있습니다.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 컨트롤러 초기화 (currentCompanyKey 확인 및 리다이렉트 처리)
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Obx(
          () => Text(
            '내 워크스페이스',
            style: const TextStyle(
              color: Color(0xFF191F28),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF3182F6)),
                SizedBox(height: 16),
                Text('로딩 중...', style: TextStyle(color: Color(0xFF6B7684))),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1152),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더 섹션
                  _buildHeader(controller),
                  const SizedBox(height: 48),

                  // 메인 콘텐츠 영역
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 768;
                      if (isDesktop) {
                        // 데스크톱: 2단 레이아웃 (8/12, 4/12)
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 왼쪽 8/12 영역
                            Expanded(
                              flex: 8,
                              child: _buildMainContent(controller),
                            ),
                            const SizedBox(width: 32),
                            // 오른쪽 4/12 영역
                            Expanded(flex: 4, child: _buildSidebar(controller)),
                          ],
                        );
                      } else {
                        // 모바일: 세로 배치
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMainContent(controller),
                            const SizedBox(height: 32),
                            _buildSidebar(controller),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// 헤더 섹션
  Widget _buildHeader(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      controller.company.value?.name ?? '내 워크스페이스',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191F28),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => Text(
                      '${controller.company.value?.name ?? ''} 팀의 합의 진행 상황입니다.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7684),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(Routes.sessionCreate);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('새 세션 시작'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3182F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 메인 콘텐츠 영역 (왼쪽 8/12)
  Widget _buildMainContent(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 진행 중인 세션 섹션
        _buildActiveSessionSection(controller),
        const SizedBox(height: 32),

        // 최근 문서 섹션 (문서 없음, 이전 합의안, Tip 포함)
        _buildRecentDocumentsSection(controller),
      ],
    );
  }

  /// 진행 중인 세션 섹션
  Widget _buildActiveSessionSection(DashboardController controller) {
    final activeSessions = controller.sessions
        .where((s) => s.status != 'final')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '진행 중',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333D4B),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${activeSessions.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3182F6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Obx(() {
          final activeSession = controller.activeSession;
          if (activeSession == null) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Text(
                  '진행 중인 세션이 없습니다',
                  style: TextStyle(color: Color(0xFF8B95A1)),
                ),
              ),
            );
          }

          return _buildActiveSessionCard(activeSession);
        }),
      ],
    );
  }

  /// 진행 중인 세션 카드
  Widget _buildActiveSessionCard(Session session) {
    final totalQuestions = 8;
    final completedCount = session.confirmedQuestionIds.length;
    final myProgress = 60; // TODO: 실제 사용자 진행률 계산
    final overallProgress = totalQuestions > 0
        ? ((completedCount / totalQuestions) * 100).toInt()
        : 0;

    final statusText =
        {
          'draft': '초안',
          'answering': '작성중',
          'ready_for_consensus': '합의 대기',
          'consensus': '합의 진행 중',
          'final': '완료',
        }[session.status] ??
        session.status;

    final statusColor = session.status == 'answering'
        ? const Color(0xFFFFB800)
        : const Color(0xFF3182F6);

    return InkWell(
      onTap: () {
        Get.toNamed(Routes.sessionHomePath(session.sessionId));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: const BorderSide(color: Color(0xFF3182F6), width: 4),
            top: const BorderSide(color: Color(0xFFE2E8F0)),
            right: const BorderSide(color: Color(0xFFE2E8F0)),
            bottom: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '지분 계약 논의', // TODO: 세션 제목 가져오기
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191F28),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '마지막 활동: 10분 전 • 김토스님 작성 중', // TODO: 실제 활동 정보
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8B95A1),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '나의 진행률 ${myProgress}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3182F6),
                      ),
                    ),
                    Text(
                      '전체 ${overallProgress}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B95A1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: overallProgress / 100,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF3182F6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 최근 문서 섹션
  Widget _buildRecentDocumentsSection(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '최근 문서 & 팁',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333D4B),
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 640;

            return GridView.count(
              crossAxisCount: isDesktop ? 2 : 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: isDesktop ? 1.1 : 1.2,
              children: [
                // 문서 없음 카드 (항상 표시)
                Container(
                  padding: const EdgeInsets.all(64),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      style: BorderStyle
                          .values[1], // dashed 스타일 (BorderStyle.solid = 0, BorderStyle.none = 1은 아니고...)
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          size: 28,
                          color: Color(0xFFD1D5DB),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '완료된 문서가 없습니다',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8B95A1),
                        ),
                      ),
                    ],
                  ),
                ),

                // 이전 프로젝트 합의안 카드 (항상 표시)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.description_outlined,
                              size: 24,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '이전 프로젝트 합의안',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333D4B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '2023.12.01',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8B95A1),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '보기 권한 없음',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8B95A1),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Icon(
                          Icons.lock_outline,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// 사이드바 영역 (오른쪽 4/12)
  Widget _buildSidebar(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 팀 멤버 카드
        _buildTeamMembersCard(controller),
        const SizedBox(height: 20),
        // Tip 카드 (사이드바로 이동)
        _buildTipCard(),
      ],
    );
  }

  /// 팀 멤버 카드
  Widget _buildTeamMembersCard(DashboardController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '팀 멤버',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333D4B),
                ),
              ),
              const SizedBox(width: 4),
              Obx(
                () => Text(
                  '${controller.members.length}명',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF8B95A1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.members.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '멤버가 없습니다',
                    style: TextStyle(color: Color(0xFF8B95A1)),
                  ),
                ),
              );
            }

            return Column(
              children: [
                ...controller.members.take(3).map((member) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                member.role == 'A'
                                    ? Icons.person
                                    : Icons.person_outline,
                                color: const Color(0xFF9CA3AF),
                                size: 20,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF34D399),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.uid, // TODO: 사용자 이름 가져오기
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333D4B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Online',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8B95A1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: controller.copyInviteCode,
                  icon: const Icon(Icons.person_add, size: 16),
                  label: const Text('+ 멤버 초대하기'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B7684),
                    side: const BorderSide(
                      color: Color(0xFFD1D5DB),
                      style: BorderStyle.solid,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Tip 카드
  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFFEFF6FF), const Color(0xFFEEF2FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBEAFE).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: Color(0xFF3182F6),
              ),
              const SizedBox(width: 8),
              const Text(
                'Tip',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3182F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '답변이 막힐 땐 \'시장 표준 데이터\'를 켜보세요. 업계 평균을 참고할 수 있습니다.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4E5968),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
