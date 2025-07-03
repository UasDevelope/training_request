import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:training_request/api/base_api_client.dart';
import 'package:training_request/models/order.dart';

class OrderRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();
  Future<List<OrderModel>> fetchBookings(String endPoint) async {
    final response = await apiClient.get(endPoint);
    return (response['bookings'] as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }

  Future<bool> proposalAcceptReject(String endPoint) async {
    try {
      final response = await apiClient.put(endPoint, {});
      log("Accept Reject Response: $response");
      return true;
    } catch (e) {
      log('Request failed: $e');
      return false;
    }
  }
}
