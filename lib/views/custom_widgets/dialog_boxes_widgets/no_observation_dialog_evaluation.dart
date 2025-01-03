
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
class NoObservationDialogEvaluationDialog extends StatelessWidget {
  const NoObservationDialogEvaluationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      //title:
      content: Text(
          "NO HAY OBSERVACIONES PARA ESTA EVALUACIÓN".toLowerCase(),
          style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.secondary),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          child: Text(
            "Bueno",
            style: AppTextStyle.getOutfit500(textSize: 18, textColor: AppColors.white),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    );
  }
}
