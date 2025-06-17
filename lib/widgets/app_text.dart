import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;

  const AppText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.black,
        decoration: decoration,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
