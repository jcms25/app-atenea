import 'dart:async';

import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/controllers/splash_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/student_parent_teacher_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/text_style.dart';
import '../custom_widgets/item_logo_rounded.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StudentParentTeacherController? studentParentTeacherController;
  SplashLoginController? splashLoginController;
  AssistantController? assistantController;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController = Provider.of<StudentParentTeacherController>(context, listen: false);
      splashLoginController = Provider.of<SplashLoginController>(context,listen: false);
      assistantController = Provider.of<AssistantController>(context,listen: false);

      Timer(const Duration(seconds: 5),(){
        splashLoginController?.checkUserAlreadyLoggedIn(studentParentTeacherController: studentParentTeacherController, assitantController: assistantController);
      });


      // checkWhetherUserLoginOrNot(appController: appController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: AppColors.primary,
          child: Stack(
            children: [
              Container(
                color: AppColors.primary,
              ),
              const Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: ItemWhiteOpacityCircle(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.asset(AppImages.title),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 280,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppStrings.title,
                            textAlign: TextAlign.center, style: CustomStyle.title),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "optimize".tr,
                          textAlign: TextAlign.center,
                          style: CustomStyle.optimize,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(style: CustomStyle.txtvalue1, children: [
                              TextSpan(text: '© ${DateTime.now().year} '),
                              const TextSpan(
                                  text: AppStrings.iGexSolutions,
                                  style: TextStyle(color: AppColors.primary)),
                              const TextSpan(text: AppStrings.copyRights),
                            ]))
                      ],
                    ),
                  )),
              const Positioned(
                bottom: 200,
                left: 0,
                right: 0,
                child: ItemLogoRounded(),
              ),
            ],
          ),
        ));
  }

}