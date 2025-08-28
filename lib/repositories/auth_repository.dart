import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:training_request/services/local/storage.dart';
import 'package:training_request/api/base_api_client.dart';
import 'package:training_request/api/api_constants.dart';
class AuthRepository {
  final BaseApiClient _apiClient = GetIt.instance<BaseApiClient>();
  Future<Map<String, dynamic>> SignupUser({
    required String fullName,
    required String contactNumber,
    required String email,
    required String password,
    required String role, // 'user' or 'serviceProvider'
    String? drivingPermitNumber,
    String? certificateNumber,
  }) async {
    final Map<String, dynamic> body = {
      "fullName": fullName,
      "email": email,
      "contactNumber": contactNumber,
      "password": password,
      "role": role,
    };

    if (role == 'serviceProvider') {
      if (drivingPermitNumber != null) {
        body['drivingPermitNumber'] = drivingPermitNumber;
      }
      if (certificateNumber != null) {
        body['certificateNumber'] = certificateNumber;
      }
    }

    final response = await _apiClient.post(
      ApiConstants.registerTrainerr,
      body,
      auth: false,
    );
    log("Response1${response}");
    if (response.containsKey('token')) {
      await LocalStorage.storeString(
        LocalStorage.AcessToken,
        response['token'],
      );
      return response;
    } else {
      throw Exception('Signup failed: token not found in response');
    }
  }

  Future<Map<String, dynamic>> LoginUser({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> body = {"email": email, "password": password};
    final response = await _apiClient.post(
      ApiConstants.login,
      body,
      auth: true,
    );
    if (response.containsKey('token')) {
      await LocalStorage.storeString(
        LocalStorage.AcessToken,
        response['token'],
      );
      return response;
    } else {
      throw Exception('Login failed: token not found in response');
    }
    return response;
  }

  Future<void> logout() async {
    try {
      // Clear all stored data
      await LocalStorage.clearAll();
      log("Logout successful: All data cleared");
    } catch (e) {
      log("Error during logout: $e");
      // Even if there's an error clearing data, we should still proceed with logout
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      log("Attempting to delete account...");
      // Call the delete account API
      await _apiClient.delete(ApiConstants.deleteAccount);
      log("Delete account API call successful");
      
      // Clear all stored data after successful deletion
      await LocalStorage.clearAll();
      log("Delete account successful: All data cleared");
    } catch (e) {
      log("Error during account deletion: $e");
      rethrow;
    }
  }
}
