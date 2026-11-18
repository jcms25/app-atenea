import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_common_message_list_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_report_message_list_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../custom_widgets/custom_loader.dart';
import 'assistant_bottom_bar.dart';
import 'assistant_classes_screen.dart';
import 'assistant_dashboard_screen.dart';
import 'package:colegia_atenea/main.dart';
import 'package:colegia_atenea/utils/jornada_deeplink.dart';

class AssistantScreen extends StatefulWidget {
  final int currentIndex;

  const AssistantScreen({super.key, required this.currentIndex});

  @override
  State<StatefulWidget> createState() {
    return AssistantScreenChild();
  }
}

class AssistantScreenChild extends State<AssistantScreen> {

  Worker? _avisoJornada;

  @override
  void initState() {
    super.initState();
    // Aviso de fichaje: con la app recién abierta (cerrada antes) y con la app ya abierta
    WidgetsBinding.instance
        .addPostFrameCallback((_) => abrirJornadaSiPendiente());
    _avisoJornada = ever(pendingDeepLink, (_) => abrirJornadaSiPendiente());
  }

  @override
  void dispose() {
    _avisoJornada?.dispose();
    super.dispose();
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
                  : assistantController.currentBottomIndexSelected == 1
                      ? 'asClassTitle'.tr
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
                  : assistantController.currentBottomIndexSelected == 1
                      ? const ChildScreen()
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
      bottomNavigationBar: const AssistantBottomBar(),
    ));
  }




}