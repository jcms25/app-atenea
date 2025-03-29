
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingLayout extends StatelessWidget {
  final Color? backgroundColor;
  const LoadingLayout({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black.withOpacity(0.1),
      color: backgroundColor ?? AppColors.black.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(130),
      child: Center(
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          colors: AppColors.rainbowColors,
          strokeWidth: 4.0,
          // pathBackgroundColor: Colors.black.withOpacity(0.05),
          pathBackgroundColor: AppColors.black.withValues(alpha: 0.05),
        ),
      ),
    );
  }
}
