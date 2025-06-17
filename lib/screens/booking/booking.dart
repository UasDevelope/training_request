import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/utils/validator.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';
import 'package:training_request/widgets/form_field.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Center(child: Image.asset(AppImages.logo, height: 100, width: 100)),

          const SizedBox(height: 16),
          const AppText(
            text: AppStrings.personalInformation,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 12),
          AppTextFormField(
            controller: TextEditingController(),
            hintText: AppStrings.enterFullName,
            validator: AppValidators.validateRequired,
            prefixIcon: AppImages.profile,
          ),
          const SizedBox(height: 12),
          AppTextFormField(
            controller: TextEditingController(),
            hintText: AppStrings.enterEmail,
            validator: AppValidators.emailValidate,
            prefixIcon: AppImages.email,
          ),
          const SizedBox(height: 12),
          AppTextFormField(
            controller: TextEditingController(),
            hintText: AppStrings.enterContactNumber,
            validator: AppValidators.phoneValidate,
            isPhoneField: true,
          ),

          const SizedBox(height: 24),
          const AppText(
            text: AppStrings.trainingDetails,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 12),
          AppTextFormField(
            controller: TextEditingController(),
            hintText: AppStrings.enterNoOfHours,
            validator: AppValidators.validateRequired,
            prefixIcon: AppImages.time,
          ),
          const SizedBox(height: 12),
          AppTextFormField(
            controller: TextEditingController(),
            hintText: AppStrings.selectDate,
            readOnly: true,
            onTap: () {},
            prefixIcon: AppImages.calendar,
          ),
          const SizedBox(height: 12),
          AppTextFormField(
            controller: TextEditingController(),
            hintText: AppStrings.enterPrice,

            validator: AppValidators.validateRequired,
            prefixIcon: AppImages.coin,
          ),

          const SizedBox(height: 12),
          AppTextFormField(
            controller: TextEditingController(),
            hintText: AppStrings.enterRequirements,
          ),

          const SizedBox(height: 24),
          AppButton(
            text: AppStrings.requestTraining,
            onPressed: () {},
            backgroundColor: AppColor.appColor,
          ),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // TODO: Handle request
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: AppColor.green,
          //       padding: const EdgeInsets.symmetric(vertical: 14),
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //     ),
          //     child: const Text(AppStrings.requestTraining, style: TextStyle(color: Colors.white)),
          //   ),
          // ),
        ],
      ),
    );
  }
}
