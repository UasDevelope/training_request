abstract class BaseApiClient {
  Future<dynamic> get(String endpoint);
  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {bool auth});
  Future<dynamic> put(String endpoint, Map<String, dynamic> body, {bool auth});
  Future<dynamic> delete(String endpoint, {bool auth});
}
