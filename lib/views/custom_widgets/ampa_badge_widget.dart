import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';

/// Distintivo "AMPA": solo se muestra a los padres que pertenecen a la AMPA.
class AmpaBadgeWidget extends StatelessWidget {
  const AmpaBadgeWidget({super.key});

  static bool get isAmpaParent {
    if ((AppSharedPreferences.getUserLoggedInRole() ?? '') != 'parent') {
      return false;
    }
    final List<String> roles =
        AppSharedPreferences.getUserData()?.userRoles ?? [];
    return roles.contains('ampa');
  }

  @override
  Widget build(BuildContext context) {
    if (!isAmpaParent) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF2B705),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'AMPA',
        style:
            AppTextStyle.getOutfit700(textSize: 11, textColor: AppColors.white),
      ),
    );
  }
}