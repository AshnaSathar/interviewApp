class JobField {
  final String id;
  final String jobField;
  final Map<String, String> jobs;

  JobField({
    required this.id,
    required this.jobField,
    required this.jobs,
  });

  factory JobField.fromMap(Map<String, dynamic> data, String id) {
    return JobField(
      id: id,
      jobField: data["job_field"] ?? "Unknown Field", // Prevents null issues
      jobs: (data["jobs"] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value.toString()),
          ) ??
          {},
    );
  }
}
