import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/core/app_routes.dart';
import 'api/service_locator.dart';
import 'core/bloc_provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getAppBlocProvider(),
      child: MaterialApp(
        initialRoute: AppRoutes.splash,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
