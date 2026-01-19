import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_demo/ui/page/team/team_select_controller.dart';

class TeamSelectPage extends StatelessWidget {
  const TeamSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeamSelectController());

    // Define Colors from the design
    const Color primaryColor = Color(0xFFFAC638);
    const Color backgroundLight = Color(0xFFF8F8F5);
    // const Color backgroundDark = Color(0xFF231E0F); // For dark mode if implemented
    const Color cardLight = Color(0xFFFFFFFF);
    // const Color cardDark = Color(0xFF2D281A); // For dark mode

    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation / Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: backgroundLight.withValues(
                alpha: 0.8,
              ), // backdrop blur simulation
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo & Brand
                  Row(
                    children: [
                      Container(
                        // Logo Box
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.handshake_outlined,
                          color: Color(0xFF231E0F), // background-dark
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Founders',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: const Color(0xFF1C180D),
                        ),
                      ),
                    ],
                  ),
                  // User Profile
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade200),
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuALH6P8og9N-80Qt5Ss3bSIoKLqjrz9mDmGY77LQ05en0SP5kYuzY3bJ-7W5dZPOeqnFSY6o9he-UjPLoYRp95NH92ulDyAcOqO4hWt_pYKsZWkVpE9MJX5ApQMOT6i9iuaPJtGpGERwKXBtWGqyQxXjovJGX6Ap8xYe_QC5PaR7V96pW4RM7oaWeHMuVy_74ZLwEPIp1w8RxxvdHPvP7JYWP51-MF10A1PXvn5Ufuki42QlpYcLrkJ-K1ZQmHjxbFA2zPQCRVBtQ",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '김대표님',
                          style: GoogleFonts.notoSansKr(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(
                              0xFF1C180D,
                            ).withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          // Headline
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: '안녕하세요, 김대표님!\n'),
                                const TextSpan(text: '어디로 이동할까요?'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKr(
                              fontSize: 28, // md:text-[32px]
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              color: const Color(0xFF1C180D),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '공동 창업자들과 함께 꿈을 실현해보세요.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKr(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Action Cards Grid
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // If width is strictly constrained (mobile), use Column
                              // But here max width is 800, so we can check screen width
                              // The design uses grid-cols-1 md:grid-cols-2
                              bool isMobile =
                                  MediaQuery.of(context).size.width < 768;

                              Widget createTeamCard = _buildActionCard(
                                title: '새로운 팀 만들기',
                                subtitle: '공동 창업자들과\n새로운 여정을 시작해보세요',
                                icon: Icons.add,
                                isFilled: true,
                                onTap: controller.goToCreate,
                              );

                              Widget joinTeamCard = _buildActionCard(
                                title: '팀 코드로 참가하기',
                                subtitle: '초대 코드가 있으신가요?\n코드를 입력하고 입장하세요',
                                icon: Icons
                                    .meeting_room_outlined, // meeting_room in material symbols usually looks like a door
                                isFilled: false,
                                onTap: controller.goToJoin,
                              );

                              if (isMobile) {
                                return Column(
                                  children: [
                                    createTeamCard,
                                    const SizedBox(height: 20),
                                    joinTeamCard,
                                  ],
                                );
                              } else {
                                return Row(
                                  children: [
                                    Expanded(child: createTeamCard),
                                    const SizedBox(width: 20),
                                    Expanded(child: joinTeamCard),
                                  ],
                                );
                              }
                            },
                          ),

                          const SizedBox(height: 56),

                          // Recent Teams Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '최근 접속한 팀',
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey.shade400,
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: const Text('전체보기'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Recent Team Card
                          Container(
                            decoration: BoxDecoration(
                              color: cardLight,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  // print('Recent Team Tapped');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      // Tea Logo/Image
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade100,
                                          ),
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                              "https://lh3.googleusercontent.com/aida-public/AB6AXuDCt2vDUQZTd7aPSlmsb86cVRqBwWwAaKTDcqlwPGQDsoSIMR4hhfjH9ZOoy9JlMsyPB-xrTb7AhILEFZAS7D7NXInWconBpSAU4uwfKOlxusdrJryYaHF3v_sKHYtv-UPdJzV1LEaKk11BkBXtc3Ai16D8Db6EYxcHqJs9EjFG2g0md7NJzON0v8NAo4LNL_ymg5A-U0SCUcREQWkcKdDcg8y2wyiSCJfwzfZILuaArLMUtcwYOw4QSxoLRFo7-1XRSd0aylZdzA",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      // Team Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Text(
                                                'ACTIVE',
                                                style: GoogleFonts.notoSansKr(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green.shade700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '우리 팀 서비스',
                                              style: GoogleFonts.notoSansKr(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(
                                                  0xFF111827,
                                                ), // gray 900
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.description_outlined,
                                                  size: 16,
                                                  color: Colors.grey.shade500,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Co-founder Agreement Draft',
                                                  style: GoogleFonts.notoSansKr(
                                                    fontSize:
                                                        13, // slightly adjusted
                                                    color: Colors.grey.shade500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Arrow Icon
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors
                                              .transparent, // hover effect not easy in flutter mobile without MouseRegion, but ok
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                '© 2024 Founders Agreement Platform. All rights reserved.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isFilled,
    required VoidCallback onTap,
  }) {
    const Color primaryColor = Color(0xFFFAC638);
    const Color cardLight = Color(0xFFFFFFFF);

    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: cardLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: primaryColor,
                  // CSS 'icon-filled' variation logic can be approximated by choosing the right IconData or weight
                  // standard material icons usually don't support weight variation easily unless using symbols
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansKr(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827), // gray 900
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansKr(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
