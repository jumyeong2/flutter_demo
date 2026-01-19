import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 앱 전역 텍스트 스타일 정의
class AppTextStyle {
  AppTextStyle._(); // private constructor로 인스턴스 생성 방지

  /// H1 (대제목)
  static TextStyle h1({Color? color}) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textPrimary,
    );
  }

  /// H2 (중제목)
  static TextStyle h2({Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textPrimary,
    );
  }

  /// H3 (소제목) - AppBar 제목 등에 사용
  static TextStyle h3({Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textPrimary,
    );
  }

  /// Body (본문)
  static TextStyle body({Color? color, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textPrimary,
    );
  }

  /// Body Medium (본문 중간 굵기)
  static TextStyle bodyMedium({Color? color, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.textPrimary,
    );
  }

  /// Body SemiBold (본문 세미볼드)
  static TextStyle bodySemiBold({Color? color, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimary,
    );
  }

  /// Caption (캡션)
  static TextStyle caption({Color? color, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textSecondary,
    );
  }

  /// Small (작은 텍스트)
  static TextStyle small({Color? color, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 12,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textTertiary,
    );
  }
}