import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/models/parent/parent_complete_registration_response.dart';
import 'package:minda_application/src/models/parent/parent_login_response.dart';
import 'package:minda_application/src/models/parent/parent_model.dart';
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

  Future<String> updateParentPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final data = {"oldPassword": oldPassword, "newPassword": newPassword};

    final response = await apiService.put('/parent/update-password', data);
    if (response.containsKey('message')) {
      final message = response["message"];
      if (message is String) {
        return message;
      } else {
        // Optionally log this for debugging.
        throw Exception("Unexpected response type for message");
      }
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
  /// Parent update profile
  /// ===========================================
  Future<ParentModel> parentUpdateProfile({
    required String firstName,
    required String lastName,
    required String birthDate,
    required String phoneNumber,
    required String addressPostal,
  }) async {
    final data = {
      "firstName": firstName,
      "lastName": lastName,
      "birthDate": birthDate,
      "phoneNumber": phoneNumber,
      "addressPostal": addressPostal
    };

    final response = await apiService.put("/parent/profile", data);
    if (response.containsKey('parent')) {
      return ParentModel.fromJson(response["parent"]);
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

  ///============================================
  /// Parent get profile
  /// ===========================================
  Future<ParentModel> getParentProfile() async {
    final response = await apiService.get("/parent/profile");
    if (response.containsKey("parent")) {
      return ParentModel.fromJson(response["parent"]);
    } else {
      throw Exception("Unexpected response format");
    }
  }

  ///============================================
  /// Parent logout
  /// ===========================================
  Future<String> parentLogout() async {
    final response = await apiService.post("/auth/logout", {});
    return response['message'];
  }
}
