import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:training_request/blocs/location/bloc.dart';
import 'package:training_request/blocs/location/event.dart';
import 'package:training_request/blocs/location/state.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    // Don't automatically request location - let user decide
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body(context));
  }
  Widget _body(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        print("Location State Changed: ${state.runtimeType}");
        
        if (state is LocationSucessState) {
          print("Navigating to main app from LocationSucessState");
          Navigator.pushNamedAndRemoveUntil(
            context, 
            AppRoutes.nav, 
            (route) => false,
          );
        }
        if (state is LocationLoadedState) {
          print("Navigating to main app from LocationLoadedState");
          Navigator.pushNamedAndRemoveUntil(
            context, 
            AppRoutes.nav, 
            (route) => false,
          );
        }
      },
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Checking location access..."),
                ],
              ),
            );
          }
          String? locationText;
          if (state is LocationLoadedState) {
            locationText = state.location;
          } else if (state is LocationErrorState) {
            // Provide more user-friendly error messages
            if (state.message.contains("Location services are disabled")) {
              locationText = "Please enable location services in your device settings to use this app.";
            } else if (state.message.contains("Location permission denied")) {
              locationText = "Location permission is required to find nearby instructors and track your training sessions. Please grant location permission in settings.";
            } else if (state.message.contains("Failed to get location")) {
              locationText = "Unable to get your current location. Please check your GPS settings and try again.";
            } else {
              locationText = "Unable to access location. Please check your device settings and try again.";
            }
          } else if (state is LocationPermissionDenied) {
            locationText = "Location permission is required to find nearby instructors and track your training sessions. Please grant location permission in settings.";
          } else {
            locationText = "This app uses your location to show driving instructors where you're requesting training from, so they can determine if they can reach your area. You can skip this for now and enable it later when making a booking.";
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImages.location, height: 150, width: 150),
                   SizedBox(height: 32),
                  AppText(
                    text: "Training Location",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColor.black,
                  ),
                   SizedBox(height: 12),
                  AppText(
                    text: locationText,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.grey,
                  ),
                   SizedBox(height: 32),
                  Column(
                    children: [
                      AppButton(
                        backgroundColor: AppColor.appColor,
                        borderRadius: 10,
                        text: state is LocationErrorState ? "Try Again" : "Continue",
                        onPressed: () {
                          print("Continue button pressed");
                          context.read<LocationBloc>().add(RequestEnableLocation());
                        },
                      ),
                      if (state is LocationErrorState || state is LocationPermissionDenied) ...[
                        const SizedBox(height: 12),
                        AppButton(
                          backgroundColor: AppColor.grey,
                          borderRadius: 10,
                          text: "Open Settings",
                          textColor: Colors.black,
                          onPressed: () async {
                            // Open app settings
                            await Geolocator.openAppSettings();
                          },
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // Allow users to skip location and proceed to main app
                          Navigator.pushNamedAndRemoveUntil(
                            context, 
                            AppRoutes.nav, 
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Skip for now",
                          style: TextStyle(
                            color: AppColor.grey,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
