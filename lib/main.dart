import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/core/app_routes.dart';

import 'core/bloc_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
