import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/blocs/user_profile/bloc.dart';
import 'package:training_request/repositories/user_profile_repository.dart';
import 'package:get_it/get_it.dart';
import '../../utils/const/app_string.dart';
import '../../utils/validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form_field.dart';
import '../../utils/toast_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
        GetIt.instance<UserProfileRepository>(),
      )..add(const LoadUserProfile()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileUpdated) {
              ToastHelper.showToast(message: state.message, type: ToastType.success);
            } else if (state is UserProfileError) {
              ToastHelper.showToast(message: state.message, type: ToastType.error);
            }
          },
          child: SingleChildScrollView(
            child: BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, state) {
              // Set controller text when data is loaded
              if (state is UserProfileLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final user = state.userData['user'] ?? {};
                  _fullNameController.text = user['fullName'] ?? '';
                  _emailController.text = user['email'] ?? '';
                  _contactNumberController.text = user['contactNumber'] ?? '';
                });
              }
              
              if (state is UserProfileLoading) {
                return Center(child: CircularProgressIndicator(color: AppColor.appColor));
              }

                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: Form(
                    key: _formKey,
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
                            backgroundColor: AppColor.appColor,
                            child: Text(
                              state is UserProfileLoaded 
                                ? (state.userName.isNotEmpty ? state.userName[0].toUpperCase() : 'U')
                                : 'U',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
                          controller: _fullNameController,
                          backgroundColor: const Color(0xffF8F7FB),
                          hintColor: AppColor.grey,
                          hintText: AppStrings.enterFullName,
                          preficColor: AppColor.blue,
                          prefixIcon: AppImages.profile,
                          validator: AppValidators.validateRequired,
                        ),
                        const SizedBox(height: 20),
                        AppText(
                          text: AppStrings.emailOrPhone,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.black,
                        ),
                        const SizedBox(height: 10),
                        AppTextFormField(
                          controller: _emailController,
                          backgroundColor: const Color(0xffF8F7FB),
                          hintColor: AppColor.grey,
                          hintText: AppStrings.enterEmail,
                          preficColor: AppColor.blue,
                          prefixIcon: AppImages.email,
                          validator: AppValidators.emailValidate,
                        ),
                        const SizedBox(height: 20),
                        AppText(
                          text: AppStrings.contactNumber,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.black,
                        ),
                        const SizedBox(height: 10),
                        AppTextFormField(
                          controller: _contactNumberController,
                          backgroundColor: const Color(0xffF8F7FB),
                          hintColor: AppColor.grey,
                          isPhoneField: true,
                          hintText: AppStrings.enterContactNumber,
                          preficColor: AppColor.blue,
                          validator: AppValidators.phoneValidate,
                        ),

                        SizedBox(height: 20),
                        AppButton(
                          backgroundColor: AppColor.appColor,
                          borderRadius: 10,
                          text: state is UserProfileUpdating ? "Updating..." : "Update Profile",
                          isDisabled: state is UserProfileUpdating,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<UserProfileBloc>().add(
                                    UpdateUserProfile(
                                      fullName: _fullNameController.text,
                                      contactNumber: _contactNumberController.text,
                                      email: _emailController.text,
                                    ),
                                  );
                            }
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
