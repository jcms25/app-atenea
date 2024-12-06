import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final String buttonTitle;
  final String? suffixIcon;
  final String? prefixIcon;
  final double? buttonHeight;
  final VoidCallback onPressed;
  final double? margin;

  const CustomButtonWidget(
      {super.key,
      required this.buttonTitle,
      this.suffixIcon,
      this.prefixIcon,
      this.buttonHeight,
      required this.onPressed,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: margin == null
            ? null
            : EdgeInsets.symmetric(
                horizontal: margin ?? 0, vertical: margin ?? 0),
        height: buttonHeight ?? 60,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(blurRadius: 10, color: AppColors.primary.withOpacity(0.1))
        ], borderRadius: BorderRadius.circular(10), color: AppColors.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prefixIcon != null
                ? SvgPicture.asset(
                    prefixIcon ?? "",
                    colorFilter: const ColorFilter.mode(
                        AppColors.white, BlendMode.srcIn),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              width: prefixIcon != null ? 5 : 0,
            ),
            Text(
              buttonTitle,
              style: AppTextStyle.getOutfit500(
                  textSize: 18, textColor: AppColors.white),
            ),
            SizedBox(
              width: suffixIcon != null ? 5 : 0,
            ),
            suffixIcon != null
                ? SvgPicture.asset(
                    suffixIcon ?? "",
                    colorFilter: const ColorFilter.mode(
                        AppColors.white, BlendMode.srcIn),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
