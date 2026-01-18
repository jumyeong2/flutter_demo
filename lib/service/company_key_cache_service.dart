import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// CompanyKeyCacheService: currentCompanyKey 캐시 관리 서비스
/// 서버(users/{uid}.currentCompanyKey)가 source of truth이며,
/// 로컬 캐시(GetStorage)는 빠른 분기를 위한 캐시입니다.
class CompanyKeyCacheService extends GetxService {
  final _storage = GetStorage();
  final _firestore = FirebaseFirestore.instance;
  
  static const String _cacheKey = 'currentCompanyKey';

  /// 서버에서 currentCompanyKey를 읽어서 로컬 캐시 갱신
  /// 
  /// [uid] 사용자 UID
  /// 
  /// 서버 값이 source of truth이므로, 불일치 시 서버 값으로 로컬을 덮어씁니다.
  Future<void> syncFromServer(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        final serverCompanyKey = userDoc.data()?['currentCompanyKey'] as String?;
        
        if (serverCompanyKey != null && serverCompanyKey.isNotEmpty) {
          // 서버 값이 있으면 로컬 캐시 갱신
          _storage.write(_cacheKey, serverCompanyKey);
        } else {
          // 서버에 값이 없으면 로컬 캐시도 삭제
          _storage.remove(_cacheKey);
        }
      }
    } catch (e) {
      // 에러 발생 시 로컬 캐시는 유지 (오프라인 대응)
      // 에러 로깅만 수행
      print('CompanyKeyCacheService: 서버 동기화 실패 - $e');
    }
  }

  /// 로컬 캐시에서 currentCompanyKey 읽기
  String? getCachedCompanyKey() {
    return _storage.read<String>(_cacheKey);
  }

  /// 로컬 캐시에 currentCompanyKey 저장
  void setCachedCompanyKey(String companyKey) {
    _storage.write(_cacheKey, companyKey);
  }

  /// 로컬 캐시에서 currentCompanyKey 삭제
  void clearCachedCompanyKey() {
    _storage.remove(_cacheKey);
  }

  /// 서버에 currentCompanyKey 업데이트 (서버가 source of truth)
  /// 
  /// [uid] 사용자 UID
  /// [companyKey] 설정할 companyKey (null이면 삭제)
  Future<void> updateServerCompanyKey(String uid, String? companyKey) async {
    try {
      if (companyKey != null && companyKey.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update({
          'currentCompanyKey': companyKey,
        });
        // 서버 업데이트 성공 시 로컬 캐시도 갱신
        _storage.write(_cacheKey, companyKey);
      } else {
        await _firestore.collection('users').doc(uid).update({
          'currentCompanyKey': null,
        });
        // 서버에서 삭제 성공 시 로컬 캐시도 삭제
        _storage.remove(_cacheKey);
      }
    } catch (e) {
      // 에러 발생 시 로컬 캐시는 업데이트하지 않음 (서버 실패 시 일관성 유지)
      throw Exception('서버 업데이트 실패: $e');
    }
  }
}
