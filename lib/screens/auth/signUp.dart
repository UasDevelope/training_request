import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/authentication/auth_bloc.dart';
import 'package:training_request/blocs/authentication/auth_state.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/toast_helper.dart';
import '../../blocs/authentication/auth_event.dart';
import '../../utils/const/app_color.dart';
import '../../utils/const/app_string.dart';
import '../../utils/validator.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }

  Widget _body() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final contactController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          Navigator.pushNamed(context, AppRoutes.location);
          ToastHelper.showToast(
            message: state.message,
            type: ToastType.success,
          );
        }
        if (state is AuthLoadingState) {
          Center(child: CircularProgressIndicator());
        }
        if (state is AuthErrorState) {
          ToastHelper.showToast(message: state.message, type: ToastType.error);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isChecked =
              state is TermsChecked ? state.isTermsChecked : false;
          return Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Image.asset(AppImages.logo, height: 120, width: 120),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: AppText(
                      text: AppStrings.createYourAccount,
                      color: AppColor.blue,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: AppText(
                      text: AppStrings.welcomeSubtitle,
                      textAlign: TextAlign.center,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColor.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Basic Info Section
                  AppText(
                    text: AppStrings.basicInfo,
                    color: AppColor.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 20),
                  // Full Name
                  AppText(
                    text: AppStrings.fullName,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                  const SizedBox(height: 10),
                  AppTextFormField(
                    controller: nameController,
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
                    controller: emailController,
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
                    controller: contactController,
                    backgroundColor: const Color(0xffF8F7FB),
                    hintColor: AppColor.grey,
                    isPhoneField: true,
                    hintText: AppStrings.enterContactNumber,
                    preficColor: AppColor.blue,
                    validator: AppValidators.phoneValidate,
                  ),
                  const SizedBox(height: 20),
                  // Password
                  AppText(
                    text: AppStrings.password,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                  const SizedBox(height: 10),
                  AppTextFormField(
                    controller: passwordController,
                    backgroundColor: const Color(0xffF8F7FB),
                    hintColor: AppColor.grey,
                    hintText: AppStrings.enterPassword,
                    preficColor: AppColor.blue,
                    prefixIcon: AppImages.password,
                    isPassword: true,
                    validator: AppValidators.passwordValidate,
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password
                  AppText(
                    text: AppStrings.confirmPassword,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                  const SizedBox(height: 10),
                  AppTextFormField(
                    controller: confirmPasswordController,
                    backgroundColor: const Color(0xffF8F7FB),
                    hintColor: AppColor.grey,
                    hintText: AppStrings.enterConfirmPassword,
                    preficColor: AppColor.blue,
                    prefixIcon: AppImages.password,
                    isPassword: true,
                    validator: (value) {
                      AppValidators.confirmPasswordValidate(
                        value,
                        passwordController.text,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  //
                  // // Permit Section
                  // AppText(
                  //   text: AppStrings.permitAndCertificate,
                  //   color: AppColor.grey,
                  //   fontSize: 16,
                  //   fontWeight: FontWeight.w800,
                  // ),
                  // const SizedBox(height: 20),

                  // // Driving Permit
                  // AppText(
                  //   text: AppStrings.drivingPermit,
                  //   fontSize: 14,
                  //   fontWeight: FontWeight.w500,
                  //   color: AppColor.black,
                  // ),
                  // const SizedBox(height: 10),
                  // AppTextFormField(
                  //   controller: permitController,
                  //   backgroundColor: const Color(0xffF8F7FB),
                  //   hintColor: AppColor.grey,
                  //   hintText: AppStrings.enterDrivingPermit,
                  //   preficColor: AppColor.blue,
                  //   prefixIcon: AppImages.drive,
                  //   validator: AppValidators.validateRequired,
                  // ),
                  // const SizedBox(height: 20),

                  // Certificate Number
                  // AppText(
                  //   text: AppStrings.certificateNumber,
                  //   fontSize: 14,
                  //   fontWeight: FontWeight.w500,
                  //   color: AppColor.black,
                  // ),
                  // const SizedBox(height: 10),
                  // AppTextFormField(
                  //   controller: certificateController,
                  //   backgroundColor: const Color(0xffF8F7FB),
                  //   hintColor: AppColor.grey,
                  //   hintText: AppStrings.enterCertificateNumber,
                  //   preficColor: AppColor.blue,
                  //   prefixIcon: AppImages.drive,
                  //   validator: AppValidators.validateRequired,
                  // ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(
                            CheckTerms(isTermChecked: !isChecked),
                          );
                        },
                      ),
                      AppText(text: AppStrings.agreeToTerms),
                    ],
                  ),
                  // Signup Button
                  AppButton(
                    backgroundColor: AppColor.appColor,
                    borderRadius: 10,
                    text: AppStrings.signup,
                    onPressed:
                        isChecked
                            ? () {
                              if (formKey.currentState!.validate()) {
                                // Submit form
                                context.read<AuthBloc>().add(
                                  SignupSubmitted(
                                    fullName: nameController.text,
                                    email: emailController.text,
                                    contactNumber: contactController.text,
                                    password: passwordController.text,
                                    role: "user",
                                  ),
                                );
                              }
                            }
                            : () {
                              ToastHelper.showToast(
                                message:
                                    "Please agree to the terms and conditions.",
                              );
                            },
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(text: AppStrings.alreadyMember),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: AppText(
                          text: AppStrings.loginHere,
                          color: AppColor.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
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
