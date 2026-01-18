import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/firestore_user.dart';
import '../model/company.dart';
import '../model/session.dart';
import '../model/document.dart';

/// FirestoreRepository: Firestore CRUD 작업을 담당하는 레포지토리
/// GetX Controller에서 사용하기 쉽도록 함수 시그니처 설계
class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== Users ====================

  /// users/{uid} 조회
  Future<FirestoreUser?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return FirestoreUser.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// users/{uid} 생성/업데이트
  Future<void> setUser(FirestoreUser user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      throw Exception('Failed to set user: $e');
    }
  }

  /// users/{uid}.currentCompanyKey 업데이트
  Future<void> updateUserCompanyKey(String uid, String? companyKey) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'currentCompanyKey': companyKey,
      });
    } catch (e) {
      throw Exception('Failed to update user companyKey: $e');
    }
  }

  // ==================== Companies ====================

  /// companies/{companyKey} 조회
  Future<Company?> getCompany(String companyKey) async {
    try {
      final doc = await _firestore.collection('companies').doc(companyKey).get();
      if (doc.exists && doc.data() != null) {
        return Company.fromJson(doc.data()!, companyKey);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get company: $e');
    }
  }

  /// companies/{companyKey} 생성
  Future<void> createCompany(Company company) async {
    try {
      await _firestore
          .collection('companies')
          .doc(company.companyKey)
          .set(company.toJson());
    } catch (e) {
      throw Exception('Failed to create company: $e');
    }
  }

  /// companies/{companyKey}.latestDocId 업데이트
  Future<void> updateCompanyLatestDocId(String companyKey, String? docId) async {
    try {
      await _firestore.collection('companies').doc(companyKey).update({
        'latestDocId': docId,
      });
    } catch (e) {
      throw Exception('Failed to update company latestDocId: $e');
    }
  }

  /// companies/{companyKey}.latestSessionId 업데이트
  Future<void> updateCompanyLatestSessionId(String companyKey, String? sessionId) async {
    try {
      await _firestore.collection('companies').doc(companyKey).update({
        'latestSessionId': sessionId,
      });
    } catch (e) {
      throw Exception('Failed to update company latestSessionId: $e');
    }
  }

  // ==================== Company Members ====================

  /// companies/{companyKey}/members/{uid} 조회
  Future<CompanyMember?> getCompanyMember(String companyKey, String uid) async {
    try {
      final doc = await _firestore
          .collection('companies')
          .doc(companyKey)
          .collection('members')
          .doc(uid)
          .get();
      if (doc.exists && doc.data() != null) {
        return CompanyMember.fromJson(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get company member: $e');
    }
  }

  /// companies/{companyKey}/members/{uid} 생성/업데이트
  Future<void> setCompanyMember(String companyKey, CompanyMember member) async {
    try {
      await _firestore
          .collection('companies')
          .doc(companyKey)
          .collection('members')
          .doc(member.uid)
          .set(member.toJson());
    } catch (e) {
      throw Exception('Failed to set company member: $e');
    }
  }

  /// companies/{companyKey}/members 목록 조회
  Future<List<CompanyMember>> getCompanyMembers(String companyKey) async {
    try {
      final snapshot = await _firestore
          .collection('companies')
          .doc(companyKey)
          .collection('members')
          .get();
      return snapshot.docs
          .map((doc) => CompanyMember.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get company members: $e');
    }
  }

  // ==================== Sessions ====================

  /// sessions/{sessionId} 조회
  Future<Session?> getSession(String sessionId) async {
    try {
      final doc = await _firestore.collection('sessions').doc(sessionId).get();
      if (doc.exists && doc.data() != null) {
        return Session.fromJson(doc.data()!, sessionId);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get session: $e');
    }
  }

  /// sessions/{sessionId} 생성
  Future<String> createSession(Session session) async {
    try {
      await _firestore
          .collection('sessions')
          .doc(session.sessionId)
          .set(session.toJson());
      return session.sessionId;
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }

  /// sessions/{sessionId} 업데이트
  Future<void> updateSession(String sessionId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update(updates);
    } catch (e) {
      throw Exception('Failed to update session: $e');
    }
  }

  /// sessions/{sessionId}.status 업데이트
  Future<void> updateSessionStatus(String sessionId, String status) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update session status: $e');
    }
  }

  /// sessions/{sessionId}.participantStatus[uid].completedCount 업데이트
  Future<void> updateParticipantCompletedCount(
    String sessionId,
    String uid,
    int completedCount,
  ) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'participantStatus.$uid.completedCount': completedCount,
      });
    } catch (e) {
      throw Exception('Failed to update participant completedCount: $e');
    }
  }

  /// sessions/{sessionId}.readyUserIds에 uid 추가 (arrayUnion)
  Future<void> addReadyUserId(String sessionId, String uid) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'readyUserIds': FieldValue.arrayUnion([uid]),
      });
    } catch (e) {
      throw Exception('Failed to add readyUserId: $e');
    }
  }

  /// sessions/{sessionId}.confirmedQuestionIds에 questionId 추가 (arrayUnion)
  Future<void> addConfirmedQuestionId(String sessionId, String questionId) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'confirmedQuestionIds': FieldValue.arrayUnion([questionId]),
      });
    } catch (e) {
      throw Exception('Failed to add confirmedQuestionId: $e');
    }
  }

  /// sessions/{sessionId}.consensusConfirmedCount increment(1)
  Future<void> incrementConsensusConfirmedCount(String sessionId) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'consensusConfirmedCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to increment consensusConfirmedCount: $e');
    }
  }

  /// sessions/{sessionId} 실시간 스트림
  Stream<DocumentSnapshot> watchSession(String sessionId) {
    return _firestore.collection('sessions').doc(sessionId).snapshots();
  }

  /// sessions/{sessionId} 상태를 ready_for_consensus로 전환 (Transaction)
  /// readyUserIds.length>=2 && status=='answering'이면 전환
  /// 이미 전환된 경우 false 반환
  Future<bool> transitionToReadyForConsensus(String sessionId) async {
    try {
      final result = await _firestore.runTransaction((transaction) async {
        final sessionRef = _firestore.collection('sessions').doc(sessionId);
        final sessionDoc = await transaction.get(sessionRef);

        if (!sessionDoc.exists) {
          throw Exception('세션을 찾을 수 없습니다');
        }

        final data = sessionDoc.data()!;
        final currentStatus = data['status'] as String?;
        final readyUserIds = List<String>.from(data['readyUserIds'] ?? []);

        // 이미 전환된 경우 false 반환
        if (currentStatus == 'ready_for_consensus' ||
            currentStatus == 'consensus' ||
            currentStatus == 'final') {
          return false;
        }

        // 조건 확인: readyUserIds.length >= 2 && status == 'answering'
        if (readyUserIds.length >= 2 && currentStatus == 'answering') {
          transaction.update(sessionRef, {
            'status': 'ready_for_consensus',
          });
          return true;
        }

        return false;
      });

      return result;
    } catch (e) {
      throw Exception('상태 전환 실패: $e');
    }
  }

  // ==================== Session Answers ====================

  /// sessions/{sessionId}/answers/{uid} 조회
  Future<SessionAnswer?> getSessionAnswer(String sessionId, String uid) async {
    try {
      final doc = await _firestore
          .collection('sessions')
          .doc(sessionId)
          .collection('answers')
          .doc(uid)
          .get();
      if (doc.exists && doc.data() != null) {
        return SessionAnswer.fromJson(doc.data()!, sessionId, uid);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get session answer: $e');
    }
  }

  /// sessions/{sessionId}/answers/{uid} 생성/업데이트
  Future<void> setSessionAnswer(SessionAnswer answer) async {
    try {
      await _firestore
          .collection('sessions')
          .doc(answer.sessionId)
          .collection('answers')
          .doc(answer.uid)
          .set(answer.toJson());
    } catch (e) {
      throw Exception('Failed to set session answer: $e');
    }
  }

  // ==================== Session Consensus ====================

  /// sessions/{sessionId}/consensus/{questionId} 조회
  Future<SessionConsensus?> getSessionConsensus(
    String sessionId,
    String questionId,
  ) async {
    try {
      final doc = await _firestore
          .collection('sessions')
          .doc(sessionId)
          .collection('consensus')
          .doc(questionId)
          .get();
      if (doc.exists && doc.data() != null) {
        return SessionConsensus.fromJson(doc.data()!, sessionId, questionId);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get session consensus: $e');
    }
  }

  /// sessions/{sessionId}/consensus/{questionId} 생성/업데이트
  Future<void> setSessionConsensus(SessionConsensus consensus) async {
    try {
      await _firestore
          .collection('sessions')
          .doc(consensus.sessionId)
          .collection('consensus')
          .doc(consensus.questionId)
          .set(consensus.toJson());
    } catch (e) {
      throw Exception('Failed to set session consensus: $e');
    }
  }

  /// sessions/{sessionId}/consensus 목록 조회
  Future<List<SessionConsensus>> getSessionConsensusList(String sessionId) async {
    try {
      final snapshot = await _firestore
          .collection('sessions')
          .doc(sessionId)
          .collection('consensus')
          .get();
      return snapshot.docs
          .map((doc) => SessionConsensus.fromJson(doc.data(), sessionId, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get session consensus list: $e');
    }
  }

  // ==================== Documents ====================

  /// documents/{docId} 조회
  Future<Document?> getDocument(String docId) async {
    try {
      final doc = await _firestore.collection('documents').doc(docId).get();
      if (doc.exists && doc.data() != null) {
        return Document.fromJson(doc.data()!, docId);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  /// documents/{docId} 생성
  Future<String> createDocument(Document document) async {
    try {
      await _firestore
          .collection('documents')
          .doc(document.docId)
          .set(document.toJson());
      return document.docId;
    } catch (e) {
      throw Exception('Failed to create document: $e');
    }
  }

  /// documents/{docId} 업데이트
  Future<void> updateDocument(String docId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('documents').doc(docId).update(updates);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  /// documents에서 companyKey의 latest 문서 조회
  Future<Document?> getLatestDocument(String companyKey) async {
    try {
      final snapshot = await _firestore
          .collection('documents')
          .where('companyKey', isEqualTo: companyKey)
          .where('latest', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return Document.fromJson(snapshot.docs.first.data(), snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get latest document: $e');
    }
  }

  /// documents에서 companyKey의 모든 문서 조회
  Future<List<Document>> getDocumentsByCompany(String companyKey) async {
    try {
      final snapshot = await _firestore
          .collection('documents')
          .where('companyKey', isEqualTo: companyKey)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Document.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get documents by company: $e');
    }
  }
}
