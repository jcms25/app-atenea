import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class CustomStyle {
  static TextStyle appBarTitle = const TextStyle(
      color: AppColors.white,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w500,
      fontSize: 20);
  static TextStyle calendarTextStyle = const TextStyle(
      color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      fontSize: 20);
  static TextStyle hello =const TextStyle(
    color: AppColors.white,
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
  static TextStyle name =const TextStyle(
    color: AppColors.white,
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w300,
    fontSize: 16,
  );
  static TextStyle cardText =const TextStyle(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w700,
    fontSize: 24,
  );

  //splash screen
  static TextStyle title = const TextStyle(
      color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      fontSize: 32);
  static TextStyle optimize = const TextStyle(
      color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w400,
      fontSize: 20);

  //Login Screen
  static TextStyle login = const TextStyle(
      color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      fontSize: 32);
  static TextStyle everything = const TextStyle(
      color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w300,
      fontSize: 24);
  static TextStyle textValue = const TextStyle(
      color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w400,
      fontSize: 18);
  static TextStyle textHintValue = TextStyle(
      // color: AppColors.secondary.withOpacity(0.4),
      color: AppColors.secondary.withValues(alpha: 0.4),
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w500,
      fontSize: 18);
  static TextStyle txtvalue1 = const TextStyle(
      color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w400,
      fontSize: 14);
  static TextStyle txtvalue2 = const TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w500,
      fontSize: 18);
  static TextStyle id = const TextStyle(
      fontFamily: 'Outfit',
      color: AppColors.white,
      fontWeight: FontWeight.w900,
      fontSize: 32);
  static TextStyle txtvalue3 = const TextStyle(
      color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      fontSize: 18);

  static TextStyle txtvalue3_1 = TextStyle(
      // color: AppColors.secondary.withOpacity(0.5),
      color: AppColors.secondary.withValues(alpha: 0.5),
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w400,
      fontSize: 18);

  static TextStyle txtvalue4 = const TextStyle(
      color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w500,
      fontSize: 16);
  static DottedLine dottedLine=  DottedLine(
    dashLength: 5,
    dashGapLength: 1,
    lineThickness: 1,
    // dashColor: AppColors.secondary.withOpacity(0.05),
    dashColor: AppColors.secondary.withValues(alpha: 0.05),
    direction: Axis.horizontal,
  );

  //assistant text style list
  static TextStyle textStyleBold = const TextStyle(
      fontFamily: "Outfit",
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.secondary
  );
  static TextStyle textStyleRegularWithOpacity_50 = TextStyle(
      fontFamily: "Outfit",
      fontSize: 16,
      fontWeight: FontWeight.w400,
      // color: AppColors.secondary.withOpacity(0.5)
      color: AppColors.secondary.withValues(alpha: 0.5)
  );

}
