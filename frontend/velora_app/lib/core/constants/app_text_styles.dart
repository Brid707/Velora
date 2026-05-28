import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle logo({required Color color}) {
    return GoogleFonts.playfairDisplay(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      color: color,
      letterSpacing: -0.8,
    );
  }

  static TextStyle logoStyle({required bool isDark}) {
    return logo(color: isDark ? AppColors.textDark : AppColors.textLight);
  }

  static TextStyle title({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: color,
      letterSpacing: -0.6,
    );
  }

  static TextStyle headerStyle({required bool isDark}) {
    return title(color: isDark ? AppColors.textDark : AppColors.textLight);
  }

  static TextStyle subtitle({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle body({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.4,
    );
  }

  static TextStyle bodyRegular({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.textLight,
      height: 1.4,
    );
  }

  static TextStyle bodyBold({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: color ?? AppColors.textLight,
      height: 1.4,
    );
  }

  static TextStyle small({required Color color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle captionStyle({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.mutedLight,
    );
  }
}
