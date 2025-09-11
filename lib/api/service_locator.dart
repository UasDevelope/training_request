import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../repositories/auth_repository.dart';
import '../repositories/user_profile_repository.dart';
import 'api_client_impl.dart';
import 'api_constants.dart';
import 'base_api_client.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<BaseApiClient>(() => ApiClientImpl(sl()));
  GetIt.instance.registerLazySingleton<AuthRepository>(() => AuthRepository());
  GetIt.instance.registerLazySingleton<UserProfileRepository>(() => UserProfileRepository());
  GetIt.I.registerSingleton<WebSocketChannel>(
    WebSocketChannel.connect(Uri.parse(ApiConstants.socketChannel)),
  );
}
