import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/const/app_color.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? prefixIcon;
  final bool isPassword;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final bool isPhoneField;
  final TextInputType textInputType;
  final void Function(String)? onCountryChanged;
  final Color hintColor;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final Color preficColor;
  const AppTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.textInputType = TextInputType.text,
    this.isPhoneField = false,
    this.onCountryChanged,
    this.readOnly = false,
    this.preficColor = AppColor.blue,
    this.isPassword = false,
    this.borderColor = const Color(0xFFE0E0E0),
    this.backgroundColor = const Color(0xffF8F7FB),
    this.textColor = Colors.black,
    this.hintColor = const Color(0xFF9E9E9E),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      readOnly: readOnly,
      obscureText: isPassword,
      keyboardType: textInputType,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: isPhoneField
            ? CountryCodePicker(
                onChanged: (code) => onCountryChanged?.call(code.dialCode!),
                initialSelection: 'US',
                showFlag: true,
                showOnlyCountryWhenClosed: false,
                textStyle: TextStyle(color: textColor, fontSize: 16),
              )
            : (prefixIcon != null &&
                    prefixIcon!.isNotEmpty // ✅ Fixed null check
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      prefixIcon!,
                      color: preficColor,
                      height: 20,
                      width: 20,
                      fit: BoxFit.contain,
                    ),
                  )
                : null),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16, color: hintColor),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
      ),
    );
  }
}
