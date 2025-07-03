import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/location/bloc.dart';
import 'package:training_request/blocs/location/event.dart';
import 'package:training_request/blocs/location/state.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body(context));
  }
  Widget _body(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationSucessState) {
          Navigator.pushNamed(context, AppRoutes.nav);
        }
      },
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          String? locationText;
          if (state is LocationLoadedState) {
            locationText = state.location;
          } else if (state is LocationErrorState) {
            locationText = "Error: ${state.message}";
          } else if (state is LocationPermissionDenied) {
            locationText = "Permission Denied";
          } else {
            locationText = AppStrings.enableLocationSubtitle;
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
                    text: AppStrings.enableLocationTitle,
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
                  AppButton(
                    backgroundColor: AppColor.appColor,
                    borderRadius: 10,
                    text: AppStrings.enableButton,
                    onPressed: () {
                      context.read<LocationBloc>().add(RequestEnableLocation());
                    },
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
