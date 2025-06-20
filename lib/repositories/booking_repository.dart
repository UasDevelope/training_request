import 'package:get_it/get_it.dart';
import 'package:training_request/api/api_constants.dart';
import 'package:training_request/api/base_api_client.dart';
import 'package:training_request/models/booking.dart';

import '../models/order.dart';

class BookingRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();

  Future<Map<String, dynamic>> bookingRequest({
    required int hours,
    required DateTime date,
    required double price,
    String? specialRequirements,
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    final body = {
      "hours": hours,
      "date": date.toUtc().toIso8601String(),
      "price": price,
      "latitude": latitude,
      "longitude": longitude,
      if (locationName != null && locationName.isNotEmpty)
        "locationName": locationName,
      if (specialRequirements != null && specialRequirements.isNotEmpty)
        "specialRequirements": specialRequirements,
    };

    final response = await apiClient.post(ApiConstants.makeBooking, body);
    return response;
  }


}
