import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient mainGradient = LinearGradient(
    colors: [AppColors.sealBrown, AppColors.maroonOak, AppColors.accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [AppColors.maroonOak, AppColors.accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient storyGradient = LinearGradient(
    colors: [AppColors.sealBrown, AppColors.maroonOak, AppColors.accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [AppColors.soySauce, AppColors.darkBackground, AppColors.sealBrown],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [AppColors.cream, AppColors.weatherBoard],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
