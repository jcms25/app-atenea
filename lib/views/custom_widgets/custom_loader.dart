
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingLayout extends StatelessWidget {
  final Color? backgroundColor;
  const LoadingLayout({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.black.withValues(alpha: 0.1),
      child: const Center(
        child: SizedBox(
          width: 60,   // Tamaño fijo
          height: 60,  // Tamaño fijo
          child: LoadingIndicator(
            indicatorType: Indicator.ballRotateChase,
            colors: AppColors.rainbowColors,
            strokeWidth: 4.0,
            pathBackgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}