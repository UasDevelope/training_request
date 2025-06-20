import 'package:get_it/get_it.dart';
import 'package:training_request/api/api_constants.dart';
import 'package:training_request/api/base_api_client.dart';
import 'package:training_request/models/transaction.dart';

class TranSactionRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();
  Future<TransactionResponse> FetchHistory() async {
    var response = await apiClient.get(ApiConstants.fetchBooking);
    return TransactionResponse.fromMap(response);
  }
}
