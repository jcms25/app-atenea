import 'package:colegia_atenea/controllers/edit_profile_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/utils/app_validations.dart';
import 'package:colegia_atenea/views/custom_widgets/back_layout_of_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  TextEditingController? emailController;
  TextEditingController? mobileController;
  TextEditingController? actualAddressController;
  TextEditingController? cityController;
  TextEditingController? postalCodeController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    actualAddressController = TextEditingController();
    cityController = TextEditingController();
    postalCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Scaffold(
      appBar: CustomAppBarWidget(
        title: Text(
          'Editar pantalla de perfil',
          style: AppTextStyle.getOutfit500(
              textSize: 20, textColor: AppColors.white),
        ),
        onLeadingIconClicked: () {
          Get.back();
        },
      ),
      body: BackgroundLayout(
        image: '',
        imageType: 0,
        childWidget: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Form(
              key: editProfileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Consumer<StudentParentTeacherController>(
                      builder:
                          (context, studentParentTeacherController, child) {
                        Userdata? userData =
                            studentParentTeacherController.loginModel?.userdata;
                        return Column(
                          children: [
                            Text(
                              studentParentTeacherController
                                          .currentLoggedInUserRole ==
                                      RoleType.student
                                  ? userData?.sFname ?? ""
                                  : studentParentTeacherController
                                              .currentLoggedInUserRole ==
                                          RoleType.parent
                                      ? userData?.pFname ?? ""
                                      : userData?.firstName ?? "",
                              style: AppTextStyle.getOutfit500(
                                  textSize: 28, textColor: AppColors.secondary),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              studentParentTeacherController
                                          .currentLoggedInUserRole ==
                                      RoleType.student
                                  ? userData?.sLname ?? ""
                                  : studentParentTeacherController
                                              .currentLoggedInUserRole ==
                                          RoleType.parent
                                      ? userData?.pLname ?? ""
                                      : userData?.lastName ?? "",
                              style: AppTextStyle.getOutfit500(
                                  textSize: 16,
                                  textColor:
                                      AppColors.secondary.withOpacity(0.5)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: emailController,
                    label: 'email'.tr,
                    validateFunction: AppValidations.valueEmptyOrNot,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: mobileController,
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    label: 'Número de teléfono',
                    textInputType: TextInputType.number,
                    validateFunction: AppValidations.valueEmptyOrNot,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Dirección',
                    style: AppTextStyle.getOutfit500(
                        textSize: 20, textColor: AppColors.secondary),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: actualAddressController,
                    validateFunction: AppValidations.valueEmptyOrNot,
                    label: "Dirección actual",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                        controller: cityController,
                        validateFunction: AppValidations.valueEmptyOrNot,
                        label: "Ciudad",
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: CustomTextField(
                        controller: postalCodeController,
                        validateFunction: AppValidations.valueEmptyOrNot,
                        textInputType: TextInputType.number,
                        inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                        label: "Código Postal",
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacherController, child) {
                      return CustomButtonWidget(
                          buttonTitle: 'Actualizar', onPressed: () {
                            if(editProfileFormKey.currentState?.validate() ?? false){}
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              )),
        ),
        circularImage:
            Consumer2<StudentParentTeacherController, EditProfileController>(
                builder: (context, studentParentTeacherController,
                    editProfileController, child) {
          return Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: studentParentTeacherController.currentLoggedInUserRole ==
                      RoleType.parent
                  ? () async {}
                  : null,
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).width * 0.06),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          "https://colegioatenea.es/wp-content/plugins/scl-rest-api/img/default_avtar.jpg"),
                      // backgroundImage: studentParentTeacherController.currentLoggedInUserRole == RoleType.parent && editProfileController.pickImageFromFile != null ? Image.file(editProfileController.pickImageFromFile?.path ?? "") :  NetworkImage(
                      //     "https://colegioatenea.es/wp-content/plugins/scl-rest-api/img/default_avtar.jpg") ,
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Visibility(
                            visible: studentParentTeacherController
                                    .currentLoggedInUserRole ==
                                RoleType.parent,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.orange),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            )))
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
