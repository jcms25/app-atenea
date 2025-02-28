import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CustomDottedLineWidget extends StatelessWidget {
  const CustomDottedLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  DottedLine(
      dashLength: 5,
      dashGapLength: 1,
      lineThickness: 1,
      // dashColor: AppColors.secondary.withOpacity(0.05),
      dashColor: AppColors.secondary.withValues(alpha: 0.05),
      direction: Axis.horizontal,
    );
  }
}
