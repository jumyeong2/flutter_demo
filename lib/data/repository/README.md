# Firestore Repository 사용 예시

## GetX Controller에서 사용하기

### 1. Repository 초기화 (main.dart)

```dart
import 'data/repository/firestore_repo.dart';

void main() async {
  // ... 기존 코드 ...
  
  // Repository 초기화
  Get.put(FirestoreRepository());
  
  runApp(const MyApp());
}
```

### 2. Controller에서 사용 예시

```dart
import 'package:get/get.dart';
import '../../data/repository/firestore_repo.dart';
import '../../data/model/session.dart';
import '../../data/model/document.dart';

class SessionController extends GetxController {
  late final FirestoreRepository _repo;
  
  final Rx<Session?> session = Rx<Session?>(null);
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    
    // 세션 ID 가져오기
    final sessionId = Get.parameters['sessionId'];
    if (sessionId != null) {
      loadSession(sessionId);
    }
  }
  
  /// 세션 로드
  Future<void> loadSession(String sessionId) async {
    try {
      isLoading.value = true;
      final sessionData = await _repo.getSession(sessionId);
      session.value = sessionData;
    } catch (e) {
      Get.snackbar('오류', '세션을 불러올 수 없습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 세션 상태 업데이트
  Future<void> updateSessionStatus(String sessionId, String status) async {
    try {
      await _repo.updateSessionStatus(sessionId, status);
    } catch (e) {
      Get.snackbar('오류', '상태 업데이트 실패: $e');
    }
  }
  
  /// 답변 저장
  Future<void> saveAnswer(String sessionId, String uid, Map<String, String> answers) async {
    try {
      final answer = SessionAnswer(
        sessionId: sessionId,
        uid: uid,
        answers: answers,
        updatedAt: DateTime.now(),
      );
      await _repo.setSessionAnswer(answer);
      
      // completedCount 계산 및 업데이트
      final completedCount = answers.length;
      await _repo.updateParticipantCompletedCount(sessionId, uid, completedCount);
      
      // 8개 이상 완료 시 readyUserIds에 추가
      if (completedCount >= 8) {
        await _repo.addReadyUserId(sessionId, uid);
      }
    } catch (e) {
      Get.snackbar('오류', '답변 저장 실패: $e');
    }
  }
  
  /// 합의 확정
  Future<void> confirmConsensus(
    String sessionId,
    String questionId,
    String finalText,
    String decidedBy,
  ) async {
    try {
      // 기존 합의 조회하여 version 확인
      final existing = await _repo.getSessionConsensus(sessionId, questionId);
      final version = existing?.version ?? 0;
      
      final consensus = SessionConsensus(
        sessionId: sessionId,
        questionId: questionId,
        finalText: finalText,
        decidedAt: DateTime.now(),
        decidedBy: decidedBy,
        version: version + 1,
      );
      
      await _repo.setSessionConsensus(consensus);
      await _repo.addConfirmedQuestionId(sessionId, questionId);
    } catch (e) {
      Get.snackbar('오류', '합의 확정 실패: $e');
    }
  }
  
  /// 문서 생성
  Future<String> generateDocument(
    String companyKey,
    String sessionId,
    String summary1p,
    List<DecisionLog> decisionLogs,
  ) async {
    try {
      final docId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final document = Document(
        docId: docId,
        companyKey: companyKey,
        sessionId: sessionId,
        createdAt: DateTime.now(),
        summary1p: summary1p,
        decisionLogs: decisionLogs,
        version: 1,
        latest: true,
      );
      
      await _repo.createDocument(document);
      
      // company의 latestDocId 업데이트
      await _repo.updateCompanyLatestDocId(companyKey, docId);
      
      // session의 finalDocId 업데이트 및 status 변경
      await _repo.updateSession(sessionId, {
        'finalDocId': docId,
        'status': 'final',
      });
      
      return docId;
    } catch (e) {
      throw Exception('문서 생성 실패: $e');
    }
  }
}
```

### 3. Company 관련 예시

```dart
class CompanyController extends GetxController {
  late final FirestoreRepository _repo;
  
  /// 회사 생성
  Future<String> createCompany(String name) async {
    try {
      final companyKey = DateTime.now().millisecondsSinceEpoch.toString();
      
      final company = Company(
        companyKey: companyKey,
        name: name,
        createdAt: DateTime.now(),
      );
      
      await _repo.createCompany(company);
      return companyKey;
    } catch (e) {
      throw Exception('회사 생성 실패: $e');
    }
  }
  
  /// 멤버 추가
  Future<void> addMember(String companyKey, String uid, String role) async {
    try {
      final member = CompanyMember(
        uid: uid,
        role: role,
        joinedAt: DateTime.now(),
      );
      
      await _repo.setCompanyMember(companyKey, member);
    } catch (e) {
      throw Exception('멤버 추가 실패: $e');
    }
  }
  
  /// 멤버십 확인
  Future<bool> isMember(String companyKey, String uid) async {
    try {
      final member = await _repo.getCompanyMember(companyKey, uid);
      return member != null;
    } catch (e) {
      return false;
    }
  }
}
```

### 4. User 관련 예시

```dart
class UserController extends GetxController {
  late final FirestoreRepository _repo;
  
  /// 사용자 생성
  Future<void> createUser(String uid, String email) async {
    try {
      final user = FirestoreUser(
        uid: uid,
        email: email,
        createdAt: DateTime.now(),
      );
      
      await _repo.setUser(user);
    } catch (e) {
      throw Exception('사용자 생성 실패: $e');
    }
  }
  
  /// currentCompanyKey 업데이트
  Future<void> updateCurrentCompanyKey(String uid, String? companyKey) async {
    try {
      await _repo.updateUserCompanyKey(uid, companyKey);
    } catch (e) {
      throw Exception('currentCompanyKey 업데이트 실패: $e');
    }
  }
}
```

### 5. 실시간 스트림 사용 예시

```dart
class SessionController extends GetxController {
  late final FirestoreRepository _repo;
  StreamSubscription? _sessionSubscription;
  
  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    
    final sessionId = Get.parameters['sessionId'];
    if (sessionId != null) {
      watchSession(sessionId);
    }
  }
  
  /// 세션 실시간 감시
  void watchSession(String sessionId) {
    _sessionSubscription = _repo.watchSession(sessionId).listen((snapshot) {
      if (snapshot.exists) {
        final sessionData = Session.fromJson(snapshot.data()!, sessionId);
        session.value = sessionData;
      }
    });
  }
  
  @override
  void onClose() {
    _sessionSubscription?.cancel();
    super.onClose();
  }
}
```
