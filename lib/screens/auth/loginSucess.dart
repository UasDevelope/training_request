import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';

class Loginsucess extends StatelessWidget {
  const Loginsucess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: Body(context));
  }

  Widget Body(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Keeps content vertically centered
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.loginSucess),

            const SizedBox(height: 24),

            AppText(
              text: AppStrings.loginSuccessTitle,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
              textAlign: TextAlign.center,
            ),

             SizedBox(height: 12),

            AppText(
              text: AppStrings.loginSuccessMessage,
              textAlign: TextAlign.center,
              color: AppColor.light_grey,
              fontSize: 16,
            ),

             SizedBox(height: 80),

            AppButton(
              borderRadius: 10,
              backgroundColor: AppColor.appColor,
              text: AppStrings.letsExplore,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.nav);
              },
            ),
          ],
        ),
      ),
    );
  }
}
