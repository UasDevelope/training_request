import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final bool isDisabled;
  final BorderSide? border;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 50,
    this.backgroundColor = const Color(0xFF007AFF),
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.icon,
    this.isDisabled = false,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            side: border ?? BorderSide.none,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
