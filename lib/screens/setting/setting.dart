import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/authentication/auth_bloc.dart';
import 'package:training_request/blocs/authentication/auth_event.dart';
import 'package:training_request/blocs/authentication/auth_state.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';

import '../edit/edit.dart';

class SettingsScreen extends StatelessWidget {
   SettingsScreen({super.key});
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
        if (state is DeleteAccountState) {
          // Navigate to login screen after account deletion
          Navigator.pushNamedAndRemoveUntil(
            context, 
            AppRoutes.login, 
            (route) => false,
          );
        }
        if (state is AuthErrorState) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: AppText(
            text: 'Setting',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                child: Image.asset(AppImages.logo, height: 60, width: 60),
              ),
            ),
            const AppText(
              text: 'Preferences',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: AppImages.editprofile,
              title: 'Profile Setting',
              subtitle: 'Edit your account information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfileScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              onTap: () {
                log("message");
                Navigator.pushNamed(context, AppRoutes.transaction);
              },
              icon: AppImages.transaction,
              title: 'Transaction History',
              subtitle: 'Check transaction history',
            ),
            const SizedBox(height: 30),
            AppText(
              text: 'Take a note',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            _SimpleOptionTile(title: 'Privacy policy'),
            const SizedBox(height: 10),
            _SimpleOptionTile(title: 'Terms & Conditions'),
            const SizedBox(height: 30),
            // Logout section
            AppText(
              text: 'Account',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            _LogoutTile(),
            const SizedBox(height: 12),
            _DeleteAccountTile(),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color? backgroundColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Image.asset(icon, color: AppColor.blue),
          title: AppText(text: title, fontWeight: FontWeight.bold),
          subtitle: AppText(
            text: subtitle,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _SimpleOptionTile extends StatelessWidget {
  final String title;

  const _SimpleOptionTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: AppColor.pastel,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        title: AppText(text: title, fontSize: 16, fontWeight: FontWeight.w600),
        trailing: Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.red[50],
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
            subtitle: AppText(
              text: state is AuthLoadingState 
                  ? 'Please wait...' 
                  : 'Sign out of your account',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.red[700],
            ),
            onTap: state is AuthLoadingState
                ? null
                : () => _showLogoutDialog(context),
          ),
        );
      },
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

class _DeleteAccountTile extends StatelessWidget {
  const _DeleteAccountTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.red[100],
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: state is AuthLoadingState 
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                : Icon(Icons.delete_forever, color: Colors.red),
            title: AppText(
              text: state is AuthLoadingState ? 'Deleting account...' : AppStrings.deleteAccount,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
            subtitle: AppText(
              text: state is AuthLoadingState 
                  ? 'Please wait...' 
                  : 'Permanently delete your account',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.red[700],
            ),
            onTap: state is AuthLoadingState
                ? null
                : () => _showDeleteAccountDialog(context),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: AppText(
            text: AppStrings.deleteAccount,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: AppStrings.deleteAccountConfirmation,
                fontSize: 14,
              ),
              const SizedBox(height: 8),
              AppText(
                text: AppStrings.deleteAccountWarning,
                fontSize: 12,
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ],
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
                context.read<AuthBloc>().add(const DeleteAccountRequest());
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
