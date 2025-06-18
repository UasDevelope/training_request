import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/splash/splash_bloc.dart';
import 'package:training_request/blocs/splash/splash_state.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/utils/const/app_img.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToHome) {
          Navigator.pushReplacementNamed(context, AppRoutes.nav);
        }

        if (state is SplashNavigateToLogin) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(AppImages.logo, height: 300, width: 300),
        ),
      ),
    );
  }
}
