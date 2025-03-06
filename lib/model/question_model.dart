class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final String answer;
  final String jobId;
  final String fieldId;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
    required this.jobId,
    required this.fieldId,
  });

  factory QuestionModel.fromMap(String id, Map<String, dynamic> map) {
    return QuestionModel(
      id: id,
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      answer: map['answer'] ?? '',
      jobId: map['jobId'] ?? '',
      fieldId: map['fieldId'] ?? '',
    );
  }
}
