import 'package:flutter/material.dart';

/// 앱 전역 색상 상수 정의
class AppColors {
  AppColors._(); // private constructor로 인스턴스 생성 방지

  // 배경색
  static const Color surface = Colors.white;
  static const Color background = Color(0xFFF9FAFB);

  // 텍스트 색상
  static const Color textPrimary = Color(0xFF191F28);
  static const Color textSecondary = Color(0xFF6B7684);
  static const Color textTertiary = Color(0xFF8B95A1);

  // 주요 액션 색상
  static const Color primary = Color(0xFF3182F6);
  static const Color warning = Color(0xFFFFB800);

  // 구분선 및 보더
  static const Color dividerGray = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFE2E8F0);

  // 기타
  static const Color lightBlue = Color(0xFFEFF6FF);
}