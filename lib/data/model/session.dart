import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore sessions/{sessionId} 모델
/// v5 스펙: companyKey, status, createdAt, questionSetVersion, participantStatus(map),
/// readyUserIds(array), confirmedQuestionIds(array 초기값 []), consensusConfirmedCount(optional), finalDocId(optional)
class Session {
  final String sessionId;
  final String companyKey;
  final String status; // 'draft' | 'answering' | 'ready_for_consensus' | 'consensus' | 'final'
  final DateTime createdAt;
  final String questionSetVersion;
  final Map<String, ParticipantStatus> participantStatus;
  final List<String> readyUserIds;
  final List<String> confirmedQuestionIds;
  final int? consensusConfirmedCount;
  final String? finalDocId;

  Session({
    required this.sessionId,
    required this.companyKey,
    required this.status,
    required this.createdAt,
    required this.questionSetVersion,
    required this.participantStatus,
    required this.readyUserIds,
    required this.confirmedQuestionIds,
    this.consensusConfirmedCount,
    this.finalDocId,
  });

  factory Session.fromJson(Map<String, dynamic> json, String sessionId) {
    final participantStatusMap = <String, ParticipantStatus>{};
    if (json['participantStatus'] != null) {
      final ps = json['participantStatus'] as Map<String, dynamic>;
      ps.forEach((key, value) {
        participantStatusMap[key] = ParticipantStatus.fromJson(
          value as Map<String, dynamic>,
        );
      });
    }

    return Session(
      sessionId: sessionId,
      companyKey: json['companyKey'] as String,
      status: json['status'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      questionSetVersion: json['questionSetVersion'] as String,
      participantStatus: participantStatusMap,
      readyUserIds: List<String>.from(json['readyUserIds'] ?? []),
      confirmedQuestionIds: List<String>.from(json['confirmedQuestionIds'] ?? []),
      consensusConfirmedCount: json['consensusConfirmedCount'] as int?,
      finalDocId: json['finalDocId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final participantStatusJson = <String, dynamic>{};
    participantStatus.forEach((key, value) {
      participantStatusJson[key] = value.toJson();
    });

    return {
      'companyKey': companyKey,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'questionSetVersion': questionSetVersion,
      'participantStatus': participantStatusJson,
      'readyUserIds': readyUserIds,
      'confirmedQuestionIds': confirmedQuestionIds,
      if (consensusConfirmedCount != null)
        'consensusConfirmedCount': consensusConfirmedCount,
      if (finalDocId != null) 'finalDocId': finalDocId,
    };
  }
}

/// ParticipantStatus 모델
/// participantStatus[uid] = { completedCount: number }
class ParticipantStatus {
  final int completedCount;

  ParticipantStatus({required this.completedCount});

  factory ParticipantStatus.fromJson(Map<String, dynamic> json) {
    return ParticipantStatus(
      completedCount: json['completedCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedCount': completedCount,
    };
  }
}

/// Firestore sessions/{sessionId}/answers/{uid} 모델
/// v5 스펙: answers(map), updatedAt
class SessionAnswer {
  final String sessionId;
  final String uid;
  final Map<String, String> answers; // questionId -> answerText
  final DateTime updatedAt;

  SessionAnswer({
    required this.sessionId,
    required this.uid,
    required this.answers,
    required this.updatedAt,
  });

  factory SessionAnswer.fromJson(Map<String, dynamic> json, String sessionId, String uid) {
    return SessionAnswer(
      sessionId: sessionId,
      uid: uid,
      answers: Map<String, String>.from(json['answers'] ?? {}),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answers': answers,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

/// Firestore sessions/{sessionId}/consensus/{questionId} 모델
/// v5 스펙: finalText, decidedAt, decidedBy, version
class SessionConsensus {
  final String sessionId;
  final String questionId;
  final String finalText;
  final DateTime decidedAt;
  final String decidedBy;
  final int version;

  SessionConsensus({
    required this.sessionId,
    required this.questionId,
    required this.finalText,
    required this.decidedAt,
    required this.decidedBy,
    required this.version,
  });

  factory SessionConsensus.fromJson(Map<String, dynamic> json, String sessionId, String questionId) {
    return SessionConsensus(
      sessionId: sessionId,
      questionId: questionId,
      finalText: json['finalText'] as String,
      decidedAt: (json['decidedAt'] as Timestamp).toDate(),
      decidedBy: json['decidedBy'] as String,
      version: json['version'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'finalText': finalText,
      'decidedAt': Timestamp.fromDate(decidedAt),
      'decidedBy': decidedBy,
      'version': version,
    };
  }
}
