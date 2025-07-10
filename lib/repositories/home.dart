import 'dart:convert';

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
      "type": "location_update",
      "latitude": lat,
      "longitude": lng,
      "userId": userId,
      "locationName": locationName,
      "status": status,
    };

    print("📤 Sending WebSocket message: ${jsonEncode(data)}");

    _channel.sink.add(jsonEncode(data));
  }
}
