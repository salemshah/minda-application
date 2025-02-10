import 'base_repository.dart';

class ParentRepository extends BaseRepository {
  ParentRepository({required super.apiService});

  /// Registers a parent using the reusable API service.
  ///
  /// Throws an Exception if the call fails.
  Future<String> registerParent({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    final data = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "password": password,
    };

    // Using the reusable POST method.
    final response = await apiService.post('/auth/parent-register', data);

    // Expecting a response like: { "message": "..." }
    return response['message'];
  }
}
