import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

/// Barra de navegación inferior del módulo de Asistencia.
/// La pestaña marcada es la que indica el controlador.
class AssistantBottomBar extends StatelessWidget {
  const AssistantBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Consumer<AssistantController>(
            builder: (context, assistantController, child) {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            onTap: (index) => assistantController
                .setCurrentBottomIndexSelected(currentBottomIndexSelected: index),
            currentIndex: assistantController.currentBottomIndexSelected,
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppImages.asDashboard,
                    colorFilter: ColorFilter.mode(
                        AppColors.greyColor, BlendMode.srcIn),
                  ),
                  label: 'Dashboard',
                  activeIcon: SvgPicture.asset(AppImages.asDashBoardActive)),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.asClasses,
                  colorFilter: ColorFilter.mode(
                      AppColors.greyColor, BlendMode.srcIn),
                ),
                label: 'classes',
                activeIcon: SvgPicture.asset(AppImages.asClassesActive),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.asMessage,
                  colorFilter: ColorFilter.mode(
                      AppColors.greyColor, BlendMode.srcIn),
                ),
                label: 'communication',
                activeIcon: SvgPicture.asset(AppImages.asMessageActive),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.sticky_note_2_outlined,
                  size: 30,
                  color: AppColors.greyColor,
                ),
                label: 'send report communication',
                activeIcon: Icon(
                  Icons.sticky_note_2_outlined,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
            ],
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          );
        }),
      ),
    );
  }
}