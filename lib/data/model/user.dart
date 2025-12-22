class User {
  final String uid;
  final String name;
  final String email;
  final String position;
  final String phoneNumber;
  final String companyName;
  final String companyDuration;
  final String industry;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.position,
    required this.phoneNumber,
    required this.companyName,
    required this.companyDuration,
    required this.industry,
    required this.createdAt,
  });

  // Firestore 문서에서 User 객체로 변환
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      position: json['position'] as String,
      phoneNumber: json['phoneNumber'] as String,
      companyName: json['companyName'] as String,
      companyDuration: json['companyDuration'] as String,
      industry: json['industry'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // User 객체를 Firestore 문서로 변환
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'position': position,
      'phoneNumber': phoneNumber,
      'companyName': companyName,
      'companyDuration': companyDuration,
      'industry': industry,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
