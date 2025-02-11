import 'package:minda_application/src/models/parent/parent_complete_registration_response.dart';
import 'package:minda_application/src/models/parent/parent_login_response.dart';
import 'base_repository.dart';

class ParentRepository extends BaseRepository {
  ParentRepository({required super.apiService});

  ///============================================
  /// Parent registration
  /// ===========================================
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

    final response = await apiService.post('/auth/parent-register', data);
    return response['message'];
  }

  ///============================================
  /// Parent login
  /// ===========================================
  Future<ParentLoginResponse> parentLogin({
    required String email,
    required String password,
  }) async {
    final data = {
      "email": email,
      "password": password,
    };

    final response = await apiService.post('/auth/parent-login', data);
    if (response.containsKey('message') &&
        response.containsKey('parent') &&
        response.containsKey('accessToken') &&
        response.containsKey('refreshToken')) {
      return ParentLoginResponse.fromJson(response);
    } else {
      throw Exception("Unexpected response format");
    }
  }

  ///============================================
  /// Parent Complete registration
  /// ===========================================
  Future<ParentCompleteRegistrationResponse> parentCompleteRegistration({
    required String birthDate,
    required String phoneNumber,
    required String addressPostal,
  }) async {
    final data = {
      "birthDate": birthDate,
      "phoneNumber": phoneNumber,
      "addressPostal": addressPostal
    };

    final response =
        await apiService.put("/parent/complete-registration", data);
    if (response.containsKey('message') && response.containsKey('parent')) {
      return ParentCompleteRegistrationResponse.fromJson(response);
    } else {
      throw Exception("Unexpected response format");
    }
  }

  ///============================================
  /// Parent email verification
  /// ===========================================
  Future<String> parentEmailVerification({required String code}) async {
    final data = {"code": code};

    final response = await apiService.post("/parent/verify-email", data);
    return response['message'];
  }

  ///============================================
  /// Parent resend email verification
  /// ===========================================
  Future<String> parentResendEmailVerification({required String email}) async {
    final data = {"email": email};
    final response =
        await apiService.post("/parent/resend-verification-email", data);
    return response['message'];
  }
}
