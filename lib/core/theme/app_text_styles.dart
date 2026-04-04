import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Heading Styles
  static TextStyle get h1 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF1A1A1A),
        letterSpacing: -0.5,
      );

  static TextStyle get h2 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF263238),
        letterSpacing: -0.3,
      );

  static TextStyle get h3 => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF37474F),
      );

  // Body Styles
  static TextStyle get bodyBold => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF455A64),
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF607D8B),
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF78909C),
      );

  // Labels & Captions
  static TextStyle get labelCaps => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF90A4AE),
        letterSpacing: 1.2,
      );

  static TextStyle get badgeText => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      );
}
