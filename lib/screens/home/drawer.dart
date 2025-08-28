// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/authentication/auth_bloc.dart';
import 'package:training_request/blocs/authentication/auth_event.dart';
import 'package:training_request/blocs/authentication/auth_state.dart';
import 'package:training_request/blocs/nav/bloc.dart';
import 'package:training_request/blocs/nav/event.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/widgets/app_text.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String profileImage; // Can be a network or asset path

  const CustomDrawer({
    Key? key,
    required this.userName,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutState) {
          // Navigate to login screen after logout
          Navigator.pushNamedAndRemoveUntil(
            context, 
            AppRoutes.login, 
            (route) => false,
          );
        }
      },
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      profileImage,
                    ), // or use NetworkImage
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Welcome back,",
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      AppText(
                        text: userName,
                        color: AppColor.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildDrawerItem(AppImages.home, "Home", () {
              Navigator.pop(context);
            }),
            _buildDrawerItem(AppImages.transaction, "Transaction History", () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.transaction);
            }),
            _buildDrawerItem(AppImages.setting, "Settings", () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.nav);
              // Navigate to settings tab
              context.read<NavBloc>().add(ChangeIndex(Index: 3));
            }),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ListTile(
                  leading: state is AuthLoadingState 
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        )
                      : Icon(Icons.logout, color: Colors.red),
                  title: AppText(
                    text: state is AuthLoadingState ? 'Logging out...' : AppStrings.logout,
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  onTap: state is AuthLoadingState
                      ? null
                      : () => _showLogoutDialog(context),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(icon, height: 30, width: 30, color: AppColor.black),
      title: AppText(
        text: title,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColor.black,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: AppText(
            text: AppStrings.logout,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: AppText(
            text: AppStrings.logoutConfirmation,
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(
                text: AppStrings.cancel,
                color: AppColor.grey,
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(const LogoutRequest());
              },
              child: AppText(
                text: AppStrings.confirm,
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}
