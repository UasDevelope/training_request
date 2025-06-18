import 'package:get_it/get_it.dart';
import 'package:training_request/api/api_constants.dart';
import 'package:training_request/api/base_api_client.dart';

class LocationRepository {
  final BaseApiClient _apiClient = GetIt.instance<BaseApiClient>();

  Future<Map<String, dynamic>> updateLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    final body = {
      "latitude": latitude,
      "longitude": longitude,
      if (locationName != null) "locationName": locationName,
    };

    final response = await _apiClient.put(
      ApiConstants.updateLocation,
      body,
    );

    return response;
  }
}
