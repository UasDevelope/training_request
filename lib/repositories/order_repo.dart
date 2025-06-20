import 'package:get_it/get_it.dart';
import 'package:training_request/api/base_api_client.dart';
import 'package:training_request/models/order.dart';

import '../api/api_constants.dart';

class OrderRepository{
  final BaseApiClient  apiClient=GetIt.instance<BaseApiClient>();
  Future<OrderResponse> fetchBooking() async {
    var response = await apiClient.get(ApiConstants.fetchBooking);
    return OrderResponse.fromMap(response);
  }
}