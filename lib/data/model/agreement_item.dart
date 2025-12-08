class AgreementItem {
  final int id;
  final String category;
  final String question;
  final String description;
  String userA;
  final String userB;
  String consensus;
  String status; // "conflict" | "resolved"
  final String aiSuggestion;
  bool isAiLoading;

  AgreementItem({
    required this.id,
    required this.category,
    required this.question,
    required this.description,
    required this.userA,
    required this.userB,
    this.consensus = "",
    this.status = "conflict",
    required this.aiSuggestion,
    this.isAiLoading = false,
  });
}
