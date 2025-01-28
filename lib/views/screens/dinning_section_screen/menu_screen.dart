import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_images.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getDinningMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (ctx, res) {
          studentParentTeacherController?.setDinningMenuResponse(
              dinningMenuResponse: null);
          studentParentTeacherController?.setIsLoading(isLoading: false);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            onLeadingIconClicked: () {
              studentParentTeacherController?.setDinningMenuResponse(
                  dinningMenuResponse: null);
              studentParentTeacherController?.setIsLoading(isLoading: false);
              Get.back();
            },
            title: Text(
              'Comedor',
              style: AppTextStyle.getOutfit600(
                  textSize: 20, textColor: AppColors.white),
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(AppImages.menuBanner),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Menú',
                      style: AppTextStyle.getOutfit600(
                          textSize: 22, textColor: AppColors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<StudentParentTeacherController>(
                      builder:
                          (context, studentParentTeacherController, child) {
                        return Visibility(
                            visible: studentParentTeacherController
                                    .dinningMenuResponse !=
                                null,
                            child: Text(
                              studentParentTeacherController
                                          .dinningMenuResponse?.menuDate ==
                                      null
                                  ? ""
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(
                                          studentParentTeacherController
                                                  .dinningMenuResponse
                                                  ?.menuDate ??
                                              "")),
                              style: AppTextStyle.getOutfit400(
                                  textSize: 20, textColor: AppColors.black),
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(child: Consumer<StudentParentTeacherController>(
                      builder:
                          (context, studentParentTeacherController, child) {
                        return studentParentTeacherController
                                    .dinningMenuResponse ==
                                null
                            ? Center(
                                child: Text(
                                  "Menú del comedor aún no ingresado",
                                  style: AppTextStyle.getOutfit500(
                                      textSize: 16,
                                      textColor: AppColors.secondary),
                                ),
                              )
                            : Column(
                                children: [
                                  Text(
                                    studentParentTeacherController
                                            .dinningMenuResponse?.menuP1 ??
                                        "",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 20,
                                        textColor: AppColors.primary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      studentParentTeacherController
                                              .dinningMenuResponse?.menuP2 ??
                                          "",
                                      style: AppTextStyle.getOutfit500(
                                          textSize: 20,
                                          textColor: AppColors.primary)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      studentParentTeacherController
                                              .dinningMenuResponse?.menuP3 ??
                                          "",
                                      style: AppTextStyle.getOutfit500(
                                          textSize: 20,
                                          textColor: AppColors.primary)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      studentParentTeacherController
                                              .dinningMenuResponse?.menuP4 ??
                                          "",
                                      style: AppTextStyle.getOutfit500(
                                          textSize: 20,
                                          textColor: AppColors.primary)),
                                ],
                              );
                      },
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(child: Image.asset(AppImages.menuImage)),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<StudentParentTeacherController>(builder:
                        (context, studentParentTeacherController, child) {
                      return RichText(
                          text: TextSpan(
                              text: 'Ver menú del mes',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  studentParentTeacherController.openUrl(
                                      url: "https://colegioatenea.es/comedor/");
                                },
                              style: AppTextStyle.getOutfit500(
                                      textSize: 20, textColor: AppColors.blue)
                                  .copyWith(
                                      decoration: TextDecoration.underline)));
                    }),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              Consumer<StudentParentTeacherController>(
                builder: (context, studentParentTeacherController, child) {
                  return Visibility(
                      visible: studentParentTeacherController.isLoading,
                      child: LoadingLayout());
                },
              )
            ],
          ),
        ));
  }
}
