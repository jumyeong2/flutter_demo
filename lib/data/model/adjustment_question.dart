class AdjustmentQuestion {
  final String id;
  final String title;
  final String description;

  AdjustmentQuestion({
    required this.id,
    required this.title,
    required this.description,
  });
}

class AdjustmentCategory {
  final String id;
  final String label;
  final List<AdjustmentQuestion> questions;

  AdjustmentCategory({
    required this.id,
    required this.label,
    required this.questions,
  });
}

