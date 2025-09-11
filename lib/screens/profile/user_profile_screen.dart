import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/user_profile/bloc.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';
import 'package:training_request/utils/toast_helper.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: AppText(
          text: 'Profile',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileLoaded) {
            // Populate form fields with user data
            _fullNameController.text = state.userData['fullName'] ?? '';
            _contactNumberController.text = state.userData['contactNumber'] ?? '';
            _emailController.text = state.userData['email'] ?? '';
          } else if (state is UserProfileUpdated) {
            ToastHelper.showToast(message: state.message, type: ToastType.success);
          } else if (state is UserProfileError) {
            ToastHelper.showToast(message: state.message, type: ToastType.error);
          }
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return Center(child: CircularProgressIndicator(color: AppColor.appColor));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColor.appColor,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          if (state is UserProfileLoaded)
                            AppText(
                              text: state.userName,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),

                    // Form Fields
                    AppText(
                      text: 'Personal Information',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                    SizedBox(height: 16),

                    // Full Name
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: AppStrings.fullName,
                        hintText: AppStrings.enterFullName,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.person, color: AppColor.appColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Contact Number
                    TextFormField(
                      controller: _contactNumberController,
                      decoration: InputDecoration(
                        labelText: AppStrings.contactNumber,
                        hintText: AppStrings.enterContactNumber,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.phone, color: AppColor.appColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: AppStrings.email,
                        hintText: AppStrings.enterEmail,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.email, color: AppColor.appColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
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
                        text: state is UserProfileUpdating ? 'Updating...' : 'Update Profile',
                        backgroundColor: AppColor.appColor,
                        textColor: Colors.white,
                        borderRadius: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
