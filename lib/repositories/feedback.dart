import 'package:get_it/get_it.dart';
import 'package:training_request/api/base_api_client.dart';

import '../api/api_constants.dart';

class FeedbackRepository {
  final BaseApiClient apiClient=GetIt.instance<BaseApiClient>();

  Future<Map<String, dynamic>> submitFeedback({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    final body = {
      'bookingId': bookingId,
      'rating': rating,
      if (comment != null) 'comment': comment,
    };

    final response = await apiClient.post(
      ApiConstants.feedback,
      body,
      auth: true,
    );

    // Assuming the response is a Map
    return response;
  }
}