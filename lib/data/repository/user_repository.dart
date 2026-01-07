import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'users';

  // 새 사용자 문서 생성
  Future<void> createUser(User user) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(user.uid)
          .set(user.toJson());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // 사용자 정보 조회
  Future<User?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return User.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // 사용자 정보 업데이트
  Future<void> updateUser(User user) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(user.uid)
          .update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // 사용자 삭제
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_collectionName).doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}

