import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore documents/{docId} 모델
/// v5 스펙: companyKey, sessionId, createdAt, summary1p, decisionLogs, version, latest(optional)
class Document {
  final String docId;
  final String companyKey;
  final String sessionId;
  final DateTime createdAt;
  final String summary1p;
  final List<DecisionLog> decisionLogs;
  final int version;
  final bool? latest;

  Document({
    required this.docId,
    required this.companyKey,
    required this.sessionId,
    required this.createdAt,
    required this.summary1p,
    required this.decisionLogs,
    required this.version,
    this.latest,
  });

  factory Document.fromJson(Map<String, dynamic> json, String docId) {
    final decisionLogsList = <DecisionLog>[];
    if (json['decisionLogs'] != null) {
      final logs = json['decisionLogs'] as List;
      for (var log in logs) {
        decisionLogsList.add(DecisionLog.fromJson(log as Map<String, dynamic>));
      }
    }

    return Document(
      docId: docId,
      companyKey: json['companyKey'] as String,
      sessionId: json['sessionId'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      summary1p: json['summary1p'] as String,
      decisionLogs: decisionLogsList,
      version: json['version'] as int? ?? 1,
      latest: json['latest'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyKey': companyKey,
      'sessionId': sessionId,
      'createdAt': Timestamp.fromDate(createdAt),
      'summary1p': summary1p,
      'decisionLogs': decisionLogs.map((log) => log.toJson()).toList(),
      'version': version,
      if (latest != null) 'latest': latest,
    };
  }
}

/// DecisionLog 모델
class DecisionLog {
  final String questionId;
  final String finalText;
  final DateTime decidedAt;
  final String decidedBy;

  DecisionLog({
    required this.questionId,
    required this.finalText,
    required this.decidedAt,
    required this.decidedBy,
  });

  factory DecisionLog.fromJson(Map<String, dynamic> json) {
    return DecisionLog(
      questionId: json['questionId'] as String,
      finalText: json['finalText'] as String,
      decidedAt: (json['decidedAt'] as Timestamp).toDate(),
      decidedBy: json['decidedBy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'finalText': finalText,
      'decidedAt': Timestamp.fromDate(decidedAt),
      'decidedBy': decidedBy,
    };
  }
}
