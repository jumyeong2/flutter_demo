import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore users/{uid} 모델
/// v5 스펙: email, createdAt, currentCompanyKey
class FirestoreUser {
  final String uid;
  final String email;
  final DateTime createdAt;
  final String? currentCompanyKey;

  FirestoreUser({
    required this.uid,
    required this.email,
    required this.createdAt,
    this.currentCompanyKey,
  });

  factory FirestoreUser.fromJson(Map<String, dynamic> json) {
    return FirestoreUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      currentCompanyKey: json['currentCompanyKey'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      if (currentCompanyKey != null)
        'currentCompanyKey': currentCompanyKey,
    };
  }
}
