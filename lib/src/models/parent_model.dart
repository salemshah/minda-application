// parent_model.dart

/// A model representing a Parent.
///
/// This model is used to encapsulate parent data and can be expanded as your API evolves.
/// Typically, sensitive information like a password is not stored in the model.
class ParentModel {
  final String email;
  final String firstName;
  final String lastName;
  // Optionally, you might have an [id] or other fields returned by your API.
  final String? id;

  ParentModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.id,
  });

  /// Creates a new ParentModel from a JSON object.
  ///
  /// Example JSON:
  /// ```json
  /// {
  ///   "id": "12345",
  ///   "email": "salemshahdev@gmail.com",
  ///   "firstName": "Salem",
  ///   "lastName": "Shah"
  /// }
  /// ```
  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] as String?,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  /// Converts the ParentModel to a JSON object.
  ///
  /// This method is useful when sending data to your API.
  /// If the API does not expect an [id] on a registration request,
  /// you can simply omit it from the JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
