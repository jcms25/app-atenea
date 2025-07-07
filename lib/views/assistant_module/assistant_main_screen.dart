import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_common_message_list_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_report_message_list_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Response;
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../custom_widgets/custom_loader.dart';
import 'assistant_dashboard_screen.dart';

class AssistantScreen extends StatefulWidget {
  final int currentIndex;

  const AssistantScreen({super.key, required this.currentIndex});

  @override
  State<StatefulWidget> createState() {
    return AssistantScreenChild();
  }
}

class AssistantScreenChild extends State<AssistantScreen> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: AppConstants.assistantKey,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            size: 30,
          ),
          onPressed: () {
            AppConstants.assistantKey.currentState!.openDrawer();
          },
        ),
        title: Consumer<AssistantController>(
          builder: (context, assistantController, child) {
            return Text(
              assistantController.currentBottomIndexSelected == 0
                  ? "desk".tr
                  : assistantController.currentBottomIndexSelected == 2
                      ? 'option1'.tr
                      : 'reportOption'.tr,
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Consumer<AssistantController>(
            builder: (context, assistantController, child) {
              return assistantController.currentBottomIndexSelected == 0
                  ? AssistantDashboard(assistantController.assistant?.displayName ?? "")
                  : assistantController.currentBottomIndexSelected == 2
                      ? const CommonMessageListScreen()
                      : const ReportListScreen(showInParent: "2");
            },
          ),
          Consumer<AssistantController>(
            builder: (context, assistantController, child) {
              return Visibility(
                  visible: assistantController.isLoading,
                  child: LoadingLayout());
            },
          )
        ],
      ),
      drawer: AssistantDrawerWidget(),
      bottomNavigationBar: Container(
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
              onTap: (index) =>
                  assistantController.setCurrentBottomIndexSelected(currentBottomIndexSelected: index),
              currentIndex: assistantController.currentBottomIndexSelected,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppImages.asDashboard,
                    ),
                    label: 'Dashboard',
                    activeIcon: SvgPicture.asset(AppImages.asDashBoardActive)),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppImages.asClasses,
                    colorFilter: const ColorFilter.mode(
                        AppColors.secondary, BlendMode.srcIn),
                  ),
                  label: 'classes',
                  activeIcon: SvgPicture.asset(AppImages.asClassesActive),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(AppImages.asMessage),
                  label: 'communication',
                  activeIcon: SvgPicture.asset(AppImages.asMessageActive),
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.sticky_note_2_outlined,
                    size: 30,
                    color: AppColors.secondary,
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
      ),
    ));
  }




}
