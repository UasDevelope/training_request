import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/const/app_color.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String hintText;
  final String? prefixIcon;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final Color hintColor;
  final Color prefixColor;
  final String? Function(T?)? validator;

  const AppDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    this.value,
    this.onChanged,
    this.prefixIcon,
    this.validator,
    this.prefixColor = AppColor.blue,
    this.borderColor = const Color(0xFFE0E0E0),
    this.backgroundColor = const Color(0xffF8F7FB),
    this.textColor = Colors.black,
    this.hintColor = const Color(0xFF9E9E9E),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null && prefixIcon!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  prefixIcon!,
                  color: prefixColor,
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
              )
            : null,
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
      dropdownColor: backgroundColor,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: textColor,
      ),
      isExpanded: true,
    );
  }
}
