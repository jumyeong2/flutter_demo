import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'team_create_controller.dart';

class TeamCreatePage extends StatelessWidget {
  const TeamCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(TeamCreateController());

    // Design Colors
    const Color primaryColor = Color(0xFF3182F6); // Toss Blue style
    const Color primaryHoverColor = Color(0xFF1B64DA);
    const Color backgroundLight = Color(0xFFF2F4F6);
    // const Color backgroundDark = Color(0xFF101622); // Dark mode placeholder

    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
        children: [
          // Background Blobs
          // White/Light background base
          Positioned.fill(child: Container(color: backgroundLight)),

          // Blobs
          Positioned(
            top: -100, // -top-[10%] approx
            left: -50, // -left-[5%] approx
            width: 500,
            height: 500,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            top: 150, // top-[20%] approx
            right: -50, // -right-[5%]
            width: 600,
            height: 600,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo.shade50.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -100, // bottom-[-10%]
            left: 100, // left-[20%]
            width: 400,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50.withValues(
                  alpha: 0.8,
                ), // sky-50 equivalent
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main Center Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 540),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 56,
                  ), // p-10 md:p-14 approx
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 60,
                        offset: const Offset(0, 20),
                        spreadRadius: -15,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Text(
                        '함께 합의를 시작할\n팀의 이름을 알려주세요',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          color: const Color(0xFF191F28), // text-[#191F28]
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 64), // mb-16 (4rem = 64px)
                      // Input Field
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: TextField(
                          autofocus: true,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 30, // text-3xl
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A), // slate-900
                          ),
                          decoration: InputDecoration(
                            hintText: '회사/팀 이름',
                            hintStyle: GoogleFonts.notoSansKr(
                              color: Colors
                                  .grey
                                  .shade300, // placeholder:text-slate-300
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                                width: 2,
                              ), // border-slate-200
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                                width: 2,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 2,
                              ), // focus:border-primary
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          cursorColor: primaryColor,
                          onChanged: controller.updateTeamName,
                        ),
                      ),
                      const SizedBox(height: 64), // mb-16
                      // Actions
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          children: [
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 64, // h-14 md:h-16 -> approx 64
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.createTeam,
                                  style:
                                      ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shadowColor: primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        // Manual shadow can be added via Container decoration if needed, but elevation is close
                                      ).copyWith(
                                        elevation: WidgetStateProperty.all(
                                          8,
                                        ), // shadow-lg approx
                                      ),
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          '생성하기',
                                          style: GoogleFonts.notoSansKr(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24), // gap-6
                            TextButton(
                              onPressed: () => Get.back(),
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Colors.grey.shade400, // text-slate-400
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                '뒤로가기',
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 18,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
