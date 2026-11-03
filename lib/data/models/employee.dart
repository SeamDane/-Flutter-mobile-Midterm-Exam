class Employee {
  Employee({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.age,
    required this.jobTitle,
    required this.department,
    this.isLocal = false,
  });

  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final int age;
  final String jobTitle;
  final String department;

  /// True for records created in-app against a backend that doesn't persist.
  final bool isLocal;

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return (f + l).toUpperCase();
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    final company = (json['company'] as Map?) ?? const {};
    return Employee(
      id: json['id'] as int?,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      jobTitle: company['title']?.toString() ?? '',
      department: company['department']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'age': age,
        'company': {'title': jobTitle, 'department': department},
      };

  Employee copyWith({int? id, bool? isLocal}) => Employee(
        id: id ?? this.id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        age: age,
        jobTitle: jobTitle,
        department: department,
        isLocal: isLocal ?? this.isLocal,
      );
}
