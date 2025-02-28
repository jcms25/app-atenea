import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/list_of_messages_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import 'class_menu_screens/class_menu_details_screen/message_detail_screen.dart';

class ChildCommunicationListScreen extends StatefulWidget {
  final String studentWpUserId;

  const ChildCommunicationListScreen(
      {super.key, required this.studentWpUserId});

  @override
  State<ChildCommunicationListScreen> createState() =>
      _ChildCommunicationListScreenState();
}

class _ChildCommunicationListScreenState
    extends State<ChildCommunicationListScreen> {
  StudentParentTeacherController? appController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      appController = Provider.of<StudentParentTeacherController>(context, listen: false);
      appController?.getListOfChildCommunication(
          wpUserId: widget.studentWpUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (result, popInvoked) {
          appController?.setIsLoading(isLoading: false);
          appController
              ?.setListOfChildCommunication(listOfChildCommunication: []);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            title: Text(
              "Envíos del Profesor",
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            ),
            onLeadingIconClicked: () {
              appController?.setIsLoading(isLoading: false);
              appController
                  ?.setListOfChildCommunication(listOfChildCommunication: []);
              Get.back();
            },
          ),
          body: Stack(
            children: [
              ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10)
                        .copyWith(top: 10),
                    child: Consumer<StudentParentTeacherController>(
                      builder: (context, appController, child) {
                        return ListView.builder(
                            itemCount:
                            appController.listOfChildCommunication.length,
                            itemBuilder: (context, index) {
                              MessageItem messageItem =
                              appController.listOfChildCommunication[index];
                              String messageDate = DateFormat("yyyy-MM-dd")
                                  .format(DateTime.parse(messageItem.mDate ?? ""));
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MessageDetailScreen(
                                               messageId: messageItem.mid ?? "", messageType: "Recibidas",)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: (Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(messageItem.subject ?? "",
                                                  style: AppTextStyle.getOutfit600(
                                                      textSize: 18,
                                                      textColor:
                                                      AppColors.secondary)),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(messageDate,
                                                style: AppTextStyle.getOutfit400(
                                                    textSize: 14,
                                                    textColor: AppColors.secondary))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Align(
                                          alignment:
                                          AlignmentDirectional.bottomStart,
                                          child: Text(messageItem.senderName ?? "-",
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 16,
                                                  // textColor: AppColors.secondary
                                                  //     .withOpacity(0.5)
                                                  textColor: AppColors.secondary.withValues(alpha: 0.5)
                                              )),
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              );
                            });
                      },
                    ),
                  )),
              Consumer<StudentParentTeacherController>(
                builder: (context,appController,child){
                  return Visibility(
                      visible: appController.isLoading,
                      child: const LoadingLayout());
                },
              )
            ],
          ),
        ));
  }
}
