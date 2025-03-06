class QuestionModel {
  final String question;
  final List<String> options;
  final String answer;
  final String type;
  final String? job_id; // ✅ Make job_id optional

  QuestionModel({
    required this.question,
    required this.options,
    required this.answer,
    required this.type,
    this.job_id,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      answer: map['answer'] ?? '',
      type: map['type'] ?? 'm_c', // Default type if missing
      job_id: map['job_id'], // ✅ Include job_id if available
    );
  }
}
