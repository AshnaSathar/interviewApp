class ApplicationModel {
  final String vacancyId;
  final String candidateName;
  final String candidateEmail;
  final String candidatePhone;
  final String resumePath;

  ApplicationModel({
    required this.vacancyId,
    required this.candidateName,
    required this.candidateEmail,
    required this.candidatePhone,
    required this.resumePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'vacancyId': vacancyId,
      'candidateName': candidateName,
      'candidateEmail': candidateEmail,
      'candidatePhone': candidatePhone,
      'resumePath': resumePath,
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      vacancyId: map['vacancyId'] ?? '',
      candidateName: map['candidateName'] ?? '',
      candidateEmail: map['candidateEmail'] ?? '',
      candidatePhone: map['candidatePhone'] ?? '',
      resumePath: map['resumePath'] ?? '',
    );
  }
}
