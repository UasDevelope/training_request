import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../repositories/auth_repository.dart';
import 'api_client_impl.dart';
import 'base_api_client.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<BaseApiClient>(() => ApiClientImpl(sl()));
  GetIt.instance.registerLazySingleton<AuthRepository>(() => AuthRepository());

}
