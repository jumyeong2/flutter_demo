import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../routes.dart';

/// MemberGuard: 팀 멤버십 확인 미들웨어
/// companies/{companyKey}/members/{uid}를 Firestore에서 확인합니다.
/// 
/// 주의: GetMiddleware의 redirect는 동기 함수이므로,
/// 비동기 검증은 페이지의 onInit에서 수행하도록 안내합니다.
/// 하지만 요구사항에 따라 여기서는 동기적으로 가능한 부분만 처리하고,
/// 실제 Firestore 검증은 별도 Service를 통해 페이지에서 수행합니다.
class MemberGuard extends GetMiddleware {
  final _storage = GetStorage();
  final _firestore = FirebaseFirestore.instance;

  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const RouteSettings(name: Routes.login);
    }

    // companyKey 가져오기
    String? companyKey = _storage.read<String>('currentCompanyKey');
    if (companyKey == null || companyKey.isEmpty) {
      return const RouteSettings(name: Routes.teamSelect);
    }

    // 비동기 검증은 페이지의 onInit에서 수행
    // 여기서는 동기적으로 가능한 부분만 처리
    return null;
  }

  /// 비동기 멤버십 검증 (페이지의 onInit에서 호출)
  /// 
  /// 반환값:
  /// - null: 멤버십 확인됨 (통과)
  /// - RouteSettings: 리다이렉트 필요
  static Future<RouteSettings?> verifyMembership(
    String companyKey,
    String userId,
    String? currentRoute,
  ) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Firestore에서 멤버십 확인
      final memberDoc = await firestore
          .collection('companies')
          .doc(companyKey)
          .collection('members')
          .doc(userId)
          .get()
          .timeout(const Duration(seconds: 5));

      // 멤버가 아니면 팀 가입 화면으로 리다이렉트
      if (!memberDoc.exists) {
        return RouteSettings(
          name: Routes.teamJoinPath(
            code: companyKey,
            redirect: currentRoute ?? Routes.dashboard,
          ),
        );
      }

      // 멤버면 통과
      return null;
    } on TimeoutException {
      // 타임아웃 시 에러 페이지로
      return RouteSettings(
        name: Routes.error,
        arguments: {
          'message': '네트워크 연결 시간이 초과되었습니다. 다시 시도해주세요.',
          'fallbackRoute': Routes.dashboard,
        },
      );
    } catch (e) {
      // Firestore read 실패 시 에러 페이지로
      return RouteSettings(
        name: Routes.error,
        arguments: {
          'message': '멤버십 확인 중 오류가 발생했습니다: ${e.toString()}',
          'fallbackRoute': Routes.dashboard,
        },
      );
    }
  }
}
