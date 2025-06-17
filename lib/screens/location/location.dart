import 'package:flutter/cupertino.dart';
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
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }

  Widget _body() {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is LocationLoadedState) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImages.location, height: 150, width: 150),
                  const SizedBox(height: 32),
                  AppText(
                    text: AppStrings.enableLocationTitle,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColor.black,
                  ),
                  const SizedBox(height: 12),
                  // AppText(text: state.lat.toString()),
                  // AppText(text: state.long.toString()),
                  AppText(text: state.location.toString()),
                  AppText(
                    text: AppStrings.enableLocationSubtitle,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.grey,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    backgroundColor: AppColor.appColor,
                    borderRadius: 10,
                    text: AppStrings.enableButton,
                    onPressed: () {
                      context.read<LocationBloc>().add(RequestEnableLocation());
                      Navigator.pushNamed(context, AppRoutes.nav);
                    },
                  ),
                ],
              ),
            ),
          );
        }

        if (state is LocationPermissionDenied) {
          return Center(child: Text("Permission Denied"));
        }

        if (state is LocationErrorState) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return const SizedBox(child: Text("data"));
      },
    );
  }
}
