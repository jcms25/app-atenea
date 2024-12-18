import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_colors.dart';

class MessageDetailScreen extends StatefulWidget {
  final String messageId;
  final String messageType;

  const MessageDetailScreen(
      {super.key, required this.messageId, required this.messageType});

  @override
  State<StatefulWidget> createState() {
    return MessageDetailScreenChild();
  }
}

class MessageDetailScreenChild extends State<MessageDetailScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getMessageDetails(
          messageId: widget.messageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController?.setIsLoading(isLoading: false);
          studentParentTeacherController?.setMessageDetailItem(
              messageDetailItem: null);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            onLeadingIconClicked: () {
              studentParentTeacherController?.setIsLoading(isLoading: false);
              studentParentTeacherController?.setMessageDetailItem(
                  messageDetailItem: null);
              Get.back();
            },
            title: Text(
              "mTitle".tr,
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Row(
                          children: [
                            Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                return CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(widget
                                              .messageType ==
                                          "Recibidas"
                                      ? studentParentTeacherController
                                              .messageDetailItem?.image ??
                                          "https://colegioatenea.es/wp-content/plugins/scl-rest-api/img/default_avtar.jpg"
                                      : studentParentTeacherController
                                              .messageDetailItem
                                              ?.recevierImage ??
                                          "https://colegioatenea.es/wp-content/plugins/scl-rest-api/img/default_avtar.jpg"),
                                  backgroundColor: AppColors.primary,
                                );
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: SizedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Consumer<
                                            StudentParentTeacherController>(
                                          builder: (context,
                                              studentParentTeacherController,
                                              child) {
                                            return Text(
                                                widget.messageType ==
                                                        "Recibidas"
                                                    ? studentParentTeacherController
                                                            .messageDetailItem
                                                            ?.name ??
                                                        "-"
                                                    : studentParentTeacherController
                                                            .messageDetailItem
                                                            ?.recevierName ??
                                                        "-",
                                                style:
                                                    AppTextStyle.getOutfit400(
                                                        textSize: 16,
                                                        textColor: AppColors
                                                            .secondary));
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Consumer<StudentParentTeacherController>(
                                        builder: (context,
                                            studentParentTeacherController,
                                            child) {
                                          return Text(
                                            studentParentTeacherController
                                                        .messageDetailItem !=
                                                    null
                                                ? DateFormat("HH:mm").format(
                                                    DateTime.parse(
                                                        studentParentTeacherController
                                                                .messageDetailItem
                                                                ?.mDate ??
                                                            ""))
                                                : "",
                                            style: AppTextStyle.getOutfit400(
                                                textSize: 14,
                                                textColor: AppColors.secondary
                                                    .withOpacity(0.5)),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return Text(
                                        studentParentTeacherController
                                                    .messageDetailItem?.mDate !=
                                                null
                                            ? DateFormat("dd/MM/-yyyy").format(
                                                DateTime.parse(
                                                    studentParentTeacherController
                                                            .messageDetailItem
                                                            ?.mDate ??
                                                        ""))
                                            : "",
                                        style: AppTextStyle.getOutfit400(
                                            textSize: 14,
                                            textColor: AppColors.secondary
                                                .withOpacity(0.5)),
                                      );
                                    },
                                  )
                                ],
                              ),
                            )),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<StudentParentTeacherController>(
                        builder:
                            (context, studentParentTeacherController, child) {
                          return Text(
                            studentParentTeacherController
                                    .messageDetailItem?.subject ??
                                "",
                            style: AppTextStyle.getOutfit600(
                                textSize: 18, textColor: AppColors.secondary),
                            textAlign: TextAlign.start,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Consumer<StudentParentTeacherController>(
                        builder:
                            (context, studentParentTeacherController, child) {
                          return Text(
                              studentParentTeacherController
                                      .messageDetailItem?.msg ??
                                  "",
                              style: AppTextStyle.getOutfit400(
                                  textSize: 18,
                                  textColor:
                                      AppColors.secondary.withOpacity(0.5)));
                        },
                      ),
                      Consumer<StudentParentTeacherController>(
                        builder:
                            (context, studentParentTeacherController, child) {
                          return Visibility(
                              visible: studentParentTeacherController
                                          .messageDetailItem?.attachments !=
                                      null &&
                                  studentParentTeacherController
                                      .messageDetailItem!
                                      .attachments!
                                      .isNotEmpty,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'asAtch'.tr,
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 16,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      studentParentTeacherController.openUrl(
                                          url: studentParentTeacherController
                                                  .messageDetailItem
                                                  ?.attachments ??
                                              "");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppColors.secondary
                                              .withOpacity(0.05)),
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        studentParentTeacherController
                                                .messageDetailItem?.attachments
                                                ?.split("/")
                                                .last ??
                                            "",
                                        style: AppTextStyle.getOutfit400(
                                            textSize: 16,
                                            textColor: AppColors.secondary),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                        },
                      )
                    ],
                  ),
                ),
              ),
              Consumer<StudentParentTeacherController>(
                  builder: (context, studentParentTeacherController, child) {
                return Visibility(
                  visible: studentParentTeacherController.isLoading,
                  child: const Center(
                    child: LoadingLayout(),
                  ),
                );
              })
            ],
          ),
        ));
  }
}
