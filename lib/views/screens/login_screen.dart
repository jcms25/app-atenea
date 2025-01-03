import 'package:colegia_atenea/controllers/assistant_controller.dart';
import 'package:colegia_atenea/controllers/splash_login_controller.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/back_layout_of_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Response;
import 'package:provider/provider.dart';

import '../../controllers/student_parent_teacher_controller.dart';
import '../../utils/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? userNameController;
  TextEditingController? passwordController;
  StudentParentTeacherController? studentParentTeacherController;
  SplashLoginController? splashLoginController;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic>? loginCredentials =
        AppSharedPreferences.getSavedLoggedInCredential();
    userNameController =
        TextEditingController(text: loginCredentials?["userName"]);
    passwordController =
        TextEditingController(text: loginCredentials?["userPassword"]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      splashLoginController =
          Provider.of<SplashLoginController>(context, listen: false);
      splashLoginController?.setSelectedRole(
          selectedRole:
              loginCredentials?['userRole'] ?? AppConstants.roleDropDown[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
      image: AppImages.logo,
      imageType: 0,
      circularImage: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.10),
          height: 160,
          width: 160,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: AppColors.primary, width: 3.0, style: BorderStyle.solid),
            borderRadius: const BorderRadius.all(Radius.circular(160)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 25,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              AppImages.logo,
              errorBuilder: (a, b, c) {
                return const Icon(
                  Icons.error_outline,
                  color: AppColors.primary,
                );
              },
            ),
          ),
        ),
      ),
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "login".tr,
            style: AppTextStyle.getOutfit600(
                textSize: 32, textColor: AppColors.secondary),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Every".tr,
            style: AppTextStyle.getOutfit300(
                textSize: 24, textColor: AppColors.secondary),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
              key: AppConstants.loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<SplashLoginController>(
                    builder: (context, splashLoginController, child) {
                      return CustomTextField(
                          controller: userNameController,
                          hintText: "Usuario",
                          validateFunction: (value) {
                            if (value.isEmpty) {
                              return "Introducir nombre de usuario";
                            }
                            return null;
                          },
                          label: "user".tr);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<SplashLoginController>(
                    builder: (context, splashLoginController, child) {
                      return CustomTextField(
                        isObscure: splashLoginController.isObscure,
                        controller: passwordController,
                        hintText: "*******",
                        validateFunction: (value) {
                          if (value.isEmpty) {
                            return "Introducir contraseña";
                          }
                          return null;
                        },
                        label: "password".tr,
                        suffixIcon: IconButton(
                          icon: Icon(
                            splashLoginController.isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            splashLoginController.setIsObscure(
                                isObscure: !splashLoginController.isObscure);
                          },
                        ),
                      );
                    },
                  )
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          Consumer<SplashLoginController>(
            builder: (context, splashLoginController, child) {
              return Row(
                children: [
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: Checkbox(
                      value: splashLoginController.isRememberMe,
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onChanged: (bool? value) {
                        splashLoginController.setIsRememberMe(
                            status: value ?? false);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      splashLoginController.setIsRememberMe(
                          status: !(splashLoginController.isRememberMe));
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "rember".tr,
                        style: AppTextStyle.getOutfit400(
                            textSize: 14, textColor: AppColors.secondary),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Consumer<StudentParentTeacherController>(
                      builder: (context, appController, child) {
                    return GestureDetector(
                      onTap: () async {
                        await appController.openUrl(
                            url:
                                "http://colegioatenea.es/solicitud-de-credenciales-de-acceso/");
                      },
                      child: Text(
                        "forgot".tr,
                        style: AppTextStyle.getOutfit400(
                            textSize: 14, textColor: AppColors.secondary),
                      ),
                    );
                  })
                ],
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: 60,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Consumer<SplashLoginController>(
                builder: (context, splashLoginController, child) {
              return DropdownButtonHideUnderline(
                  child: DropdownButton(
                icon: SvgPicture.asset(
                  AppImages.dropdown,
                  height: 5,
                  width: 15,
                  fit: BoxFit.scaleDown,
                ),
                value: splashLoginController.currentSelectedRole,
                items: AppConstants.roleDropDown.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: AppTextStyle.getOutfit500(
                          textSize: 18, textColor: AppColors.secondary),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  splashLoginController.setSelectedRole(
                      selectedRole: newValue ?? AppConstants.roleDropDown[0]);
                },
              ));
            }),
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer3<SplashLoginController, StudentParentTeacherController,
              AssistantController>(
            builder: (context, splashLoginController, appController,
                assistantController, child) {
              return CustomButtonWidget(
                buttonTitle: "singin".tr,
                suffixIcon: AppImages.loginArrow,
                onPressed: () async {
                  if (AppConstants.loginFormKey.currentState?.validate() ??
                      false) {
                    if (splashLoginController.currentSelectedRole !=
                        AppConstants.roleDropDown[0]) {
                      await splashLoginController.userLogin(
                          userName: userNameController?.text.trim() ?? "",
                          userPassword: passwordController?.text.trim() ?? "",
                          userRole: splashLoginController.currentSelectedRole,
                          isRememberMe: splashLoginController.isRememberMe,
                          studentParentTeacherController: appController,
                          assistantController: assistantController);
                    } else {
                      AppConstants.showCustomToast(
                          status: false,
                          message: "Por favor seleccione perfil");
                    }
                  }
                },
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      childWidgetMarginFromTop: EdgeInsets.only(top: 150),
      loadingWidget: Consumer<SplashLoginController>(
        builder: (context, splashLoginController, child) {
          return Visibility(
              visible: splashLoginController.isLoading,
              child: const LoadingLayout());
        },
      ),
    );
  }
}
