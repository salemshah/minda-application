class ParentModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool status;
  final DateTime birthDate;
  final String phoneNumber;
  final String addressPostal;
  final DateTime createdAt;
  final DateTime updatedAt;

  ParentModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.birthDate,
    required this.phoneNumber,
    required this.addressPostal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      status: json['status'] as bool,
      birthDate: DateTime.parse(json['birthDate'] as String),
      phoneNumber: json['phoneNumber'] as String,
      addressPostal: json['addressPostal'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'status': status,
      'birthDate': birthDate.toIso8601String(),
      'phoneNumber': phoneNumber,
      'addressPostal': addressPostal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
