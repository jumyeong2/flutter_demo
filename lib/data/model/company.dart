import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore companies/{companyKey} 모델
/// v5 스펙: name, createdAt, latestDocId, latestSessionId
class Company {
  final String companyKey;
  final String name;
  final DateTime createdAt;
  final String? latestDocId;
  final String? latestSessionId;

  Company({
    required this.companyKey,
    required this.name,
    required this.createdAt,
    this.latestDocId,
    this.latestSessionId,
  });

  factory Company.fromJson(Map<String, dynamic> json, String companyKey) {
    return Company(
      companyKey: companyKey,
      name: json['name'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      latestDocId: json['latestDocId'] as String?,
      latestSessionId: json['latestSessionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      if (latestDocId != null) 'latestDocId': latestDocId,
      if (latestSessionId != null) 'latestSessionId': latestSessionId,
    };
  }
}

/// Firestore companies/{companyKey}/members/{uid} 모델
/// v5 스펙: role, joinedAt
class CompanyMember {
  final String uid;
  final String role; // 'A' | 'B'
  final DateTime joinedAt;

  CompanyMember({
    required this.uid,
    required this.role,
    required this.joinedAt,
  });

  factory CompanyMember.fromJson(Map<String, dynamic> json, String uid) {
    return CompanyMember(
      uid: uid,
      role: json['role'] as String,
      joinedAt: (json['joinedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }
}
