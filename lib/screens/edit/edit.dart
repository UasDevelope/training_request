import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/widgets/app_text.dart';

import '../../utils/const/app_string.dart';
import '../../utils/validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Row(
                children: [
                  BackButton(),
                  SizedBox(width: 20),
                  AppText(
                    text: "Edit Profile",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  child: Image.asset(AppImages.person1),
                ),
              ),
              AppText(text: 'Basic Info', color: AppColor.grey),
              AppText(
                text: AppStrings.fullName,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                controller: TextEditingController(),
                backgroundColor: const Color(0xffF8F7FB),
                hintColor: AppColor.grey,
                hintText: AppStrings.enterFullName,
                preficColor: AppColor.blue,
                prefixIcon: AppImages.profile,
                validator: AppValidators.validateRequired,
              ),
              const SizedBox(height: 20),

              // Email
              AppText(
                text: AppStrings.emailOrPhone,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                controller: TextEditingController(),
                backgroundColor: const Color(0xffF8F7FB),
                hintColor: AppColor.grey,
                hintText: AppStrings.enterEmail,
                preficColor: AppColor.blue,
                prefixIcon: AppImages.email,
                validator: AppValidators.emailValidate,
              ),
              const SizedBox(height: 20),

              // Contact Number
              AppText(
                text: AppStrings.contactNumber,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                controller: TextEditingController(),
                backgroundColor: const Color(0xffF8F7FB),
                hintColor: AppColor.grey,
                isPhoneField: true,
                hintText: AppStrings.enterContactNumber,
                preficColor: AppColor.blue,
                validator: AppValidators.phoneValidate,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 24),

              // Permit Section
              AppText(
                text: AppStrings.permitAndCertificate,
                color: AppColor.grey,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              const SizedBox(height: 20),

              // Driving Permit
              AppText(
                text: AppStrings.drivingPermit,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                controller: TextEditingController(),
                backgroundColor: const Color(0xffF8F7FB),
                hintColor: AppColor.grey,
                hintText: AppStrings.enterDrivingPermit,
                preficColor: AppColor.blue,
                prefixIcon: AppImages.drive,
                validator: AppValidators.validateRequired,
              ),
              const SizedBox(height: 20),

              // Certificate Number
              AppText(
                text: AppStrings.certificateNumber,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                controller: TextEditingController(),
                backgroundColor: const Color(0xffF8F7FB),
                hintColor: AppColor.grey,
                hintText: AppStrings.enterCertificateNumber,
                preficColor: AppColor.blue,
                prefixIcon: AppImages.drive,
                validator: AppValidators.validateRequired,
              ),

              // Signup Button
              SizedBox(height: 20),
              AppButton(
                backgroundColor: AppColor.appColor,
                borderRadius: 10,
                text: "Continue",
                onPressed: () {
                  // if (formKey.currentState!.validate()) {
                  //   // Submit form
                  //   Navigator.pushNamed(context, AppRoutes.location);
                  // }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
