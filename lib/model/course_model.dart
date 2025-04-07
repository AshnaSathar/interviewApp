class CourseModel {
  final String id;
  final String title;
  final String content;
  final String difficulty;

  CourseModel({
    required this.id,
    required this.title,
    required this.content,
    required this.difficulty,
  });

  factory CourseModel.fromMap(String id, Map<String, dynamic> map) {
    return CourseModel(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      difficulty: map['difficulty'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'difficulty': difficulty,
    };
  }
}
