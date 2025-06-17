import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/widgets/app_text.dart';

import '../edit/edit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
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
