import 'package:get_it/get_it.dart';
import 'package:training_request/api/base_api_client.dart';
import '../api/api_constants.dart';

class UserProfileRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();

  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await apiClient.get(
      ApiConstants.userProfile,
    );
    return response;
  }

  Future<Map<String, dynamic>> updateUserProfile({
    required String fullName,
    required String contactNumber,
    String? email,
  }) async {
    final body = {
      'fullName': fullName,
      'contactNumber': contactNumber,
      if (email != null) 'email': email,
    };

    final response = await apiClient.put(
      ApiConstants.updateUserProfile,
      body,
    );
    return response;
  }
}
