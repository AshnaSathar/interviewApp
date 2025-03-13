class VacancyModel {
  final String id;
  final String jobPosition;
  final String companyName;
  final String location;
  final String companyAddress;
  final String phoneNumber;
  final String email;
  final int salary; // now an int
  final String place;
  final String description;
  final String jobType;
  final List<String> preferredSkills;
  final List<String> languagePreferred;
  final int experience; // in years
  final int? ageFrom;
  final int? ageTo;

  VacancyModel({
    required this.id,
    required this.jobPosition,
    required this.companyName,
    required this.location,
    required this.companyAddress,
    required this.phoneNumber,
    required this.email,
    required this.salary,
    required this.place,
    required this.description,
    required this.jobType,
    required this.preferredSkills,
    required this.languagePreferred,
    required this.experience,
    required this.ageFrom,
    required this.ageTo,
  });

  factory VacancyModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return VacancyModel(
      id: id ?? map['id'] ?? '',
      jobPosition: map['jobPosition'] ?? '',
      companyName: map['companyName'] ?? '',
      location: map['location'] ?? '',
      companyAddress: map['companyAddress'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      salary: map['salary'] is int
          ? map['salary']
          : int.tryParse(map['salary']?.toString() ?? '0') ?? 0,
      place: map['place'] ?? '',
      description: map['description'] ?? '',
      jobType: map['jobType'] ?? '',
      preferredSkills: List<String>.from(map['preferredSkills'] ?? []),
      languagePreferred: List<String>.from(map['languagePreferred'] ?? []),
      experience: map['experience'] is int
          ? map['experience']
          : int.tryParse(map['experience']?.toString() ?? '0') ?? 0,
      ageFrom: map['ageFrom'] is int
          ? map['ageFrom']
          : int.tryParse(map['ageFrom']?.toString() ?? ''),
      ageTo: map['ageTo'] is int
          ? map['ageTo']
          : int.tryParse(map['ageTo']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobPosition': jobPosition,
      'companyName': companyName,
      'location': location,
      'companyAddress': companyAddress,
      'phoneNumber': phoneNumber,
      'email': email,
      'salary': salary,
      'place': place,
      'description': description,
      'jobType': jobType,
      'preferredSkills': preferredSkills,
      'languagePreferred': languagePreferred,
      'experience': experience,
      'ageFrom': ageFrom,
      'ageTo': ageTo,
    };
  }
}
