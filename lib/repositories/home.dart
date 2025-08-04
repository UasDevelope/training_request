import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeRepository {
  final WebSocketChannel _channel = GetIt.I<WebSocketChannel>();

  Future<void> updateLocationEvent(
    double lat,
    double lng,
    String? locationName,
    String userId,
    String status,
  ) async {
    final data = {
      'latitude': lat,
      'longitude': lng,
      'locationName': locationName,
      'bookingId': "687dcd2a29b7250e22e713ac",
      'updateType': 'continuous'
    };
  }
}
