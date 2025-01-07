import 'package:cached_network_image/cached_network_image.dart';
import 'package:colegia_atenea/controllers/edit_profile_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/utils/app_validations.dart';
import 'package:colegia_atenea/views/custom_widgets/back_layout_of_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../services/app_shared_preferences.dart';
import '../../utils/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  final Userdata? userdata;
  final RoleType? roleType;

  const EditProfileScreen(
      {super.key, required this.userdata, required this.roleType});

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
  TextEditingController? nifController;

  EditProfileController? editProfileController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
        text: widget.roleType == RoleType.teacher
            ? widget.userdata?.teacherEmail ?? ""
            : widget.roleType == RoleType.parent
                ? widget.userdata?.parentEmail ?? ""
                : widget.userdata?.stuEmail ?? "");
    mobileController = TextEditingController(
        text: widget.roleType == RoleType.teacher
            ? widget.userdata?.phone ?? ""
            : widget.roleType == RoleType.parent
                ? widget.userdata?.pPhone ?? ""
                : widget.userdata?.sPhone ?? "");
    actualAddressController = TextEditingController(
        text: widget.roleType == RoleType.teacher
            ? widget.userdata?.address ?? ""
            : widget.roleType == RoleType.parent
                ? widget.userdata?.sPaddress ?? ""
                : widget.userdata?.sAddress ?? "");
    cityController = TextEditingController(
        text: widget.roleType == RoleType.teacher
            ? widget.userdata?.city ?? ""
            : widget.roleType == RoleType.parent
                ? widget.userdata?.sPCity ?? ""
                : widget.userdata?.sCity ?? "");
    postalCodeController = TextEditingController(
        text: widget.roleType == RoleType.teacher
            ? widget.userdata?.zipcode ?? ""
            : widget.roleType == RoleType.parent
                ? widget.userdata?.sPZipCode ?? ""
                : widget.userdata?.sZipcode ?? "");
    nifController = TextEditingController(
        text: widget.roleType == RoleType.teacher
            ? widget.userdata?.empCode ?? ""
            : "");

    WidgetsBinding.instance.addPostFrameCallback((res) {
      editProfileController =
          Provider.of<EditProfileController>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          editProfileController?.setIsLoading(isLoading: false);
          editProfileController?.setPickedImageFromFile(
              pickImageFromFile: null);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            title: Text(
              'Editar pantalla de perfil',
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            ),
            onLeadingIconClicked: () {
              editProfileController?.setIsLoading(isLoading: false);
              editProfileController?.setPickedImageFromFile(
                  pickImageFromFile: null);
              Get.back();
            },
          ),
          body: Stack(
            children: [
              BackgroundLayout(
                image: '',
                imageType: 0,
                childWidgetMarginFromTop: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.08),
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
                              builder: (context, studentParentTeacherController,
                                  child) {
                                Userdata? userData =
                                    studentParentTeacherController.userdata;
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
                                          textSize: 28,
                                          textColor: AppColors.secondary),
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
                                          textColor: AppColors.secondary
                                              .withOpacity(0.5)),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                         Consumer<StudentParentTeacherController>(
                           builder: (context,studentParentTeacherController,child){
                             return Visibility(
                                 visible: studentParentTeacherController.currentLoggedInUserRole == RoleType.teacher,
                                 child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 const SizedBox(
                                   height: 20,
                                 ),
                                 CustomTextField(
                                   controller: nifController,
                                   label: 'NIF',
                                   validateFunction: AppValidations.valueEmptyOrNot,
                                 )
                               ],
                             ));
                           },
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

                          CustomTextField(
                            controller: mobileController,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                                validateFunction:
                                    AppValidations.valueEmptyOrNot,
                                label: "Ciudad",
                              )),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: CustomTextField(
                                controller: postalCodeController,
                                validateFunction:
                                    AppValidations.valueEmptyOrNot,
                                textInputType: TextInputType.number,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                label: "Código Postal",
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Consumer2<StudentParentTeacherController,
                              EditProfileController>(
                            builder: (context, studentParentTeacherController,
                                editingProfileController, child) {
                              return CustomButtonWidget(
                                  buttonTitle: 'Actualizar',
                                  onPressed: () async {
                                    if (editProfileFormKey.currentState
                                            ?.validate() ??
                                        false) {
                                      if (studentParentTeacherController
                                                  .currentLoggedInUserRole ==
                                              RoleType.parent &&
                                          editingProfileController
                                                  .pickImageFromFile !=
                                              null) {
                                        await editingProfileController.updateProfile(
                                            role: RoleType.parent,
                                            cookies:
                                                studentParentTeacherController
                                                        .userdata?.cookies ??
                                                    "",
                                            wpUserId:
                                                studentParentTeacherController
                                                        .userdata
                                                        ?.parentWpUsrId ??
                                                    "",
                                            actualAddress:
                                                actualAddressController?.text,
                                            city: cityController?.text,
                                            email: emailController?.text,
                                            mobileNumber:
                                                mobileController?.text,
                                            postalCode:
                                                postalCodeController?.text,
                                            profileImage:
                                                editingProfileController
                                                        .pickImageFromFile
                                                        ?.path ??
                                                    "",
                                            nif: studentParentTeacherController
                                                        .currentLoggedInUserRole ==
                                                    RoleType.teacher
                                                ? nifController?.text ?? ""
                                                : null,
                                            studentParentTeacherController:
                                                studentParentTeacherController);
                                      } else {
                                        String wpUserId = studentParentTeacherController
                                                        .currentLoggedInUserRole ==
                                                    RoleType.teacher ||
                                                studentParentTeacherController
                                                        .currentLoggedInUserRole ==
                                                    RoleType.student
                                            ? studentParentTeacherController
                                                    .userdata?.wpUsrId ??
                                                ""
                                            : studentParentTeacherController
                                                    .userdata?.parentWpUsrId ??
                                                "";
                                        await editingProfileController.updateProfile(
                                            role: studentParentTeacherController
                                                .currentLoggedInUserRole,
                                            cookies:
                                                studentParentTeacherController
                                                        .userdata?.cookies ??
                                                    "",
                                            wpUserId: wpUserId,
                                            studentParentTeacherController:
                                                studentParentTeacherController,
                                            actualAddress:
                                                actualAddressController?.text,
                                            city: cityController?.text,
                                            email: emailController?.text,
                                            mobileNumber:
                                                mobileController?.text,
                                            postalCode:
                                                postalCodeController?.text,
                                            nif: studentParentTeacherController
                                                        .currentLoggedInUserRole ==
                                                    RoleType.teacher
                                                ? nifController?.text ?? ""
                                                : null);
                                      }
                                    }
                                  });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      )),
                ),
                circularImage: Consumer2<StudentParentTeacherController,
                        EditProfileController>(
                    builder: (context, studentParentTeacherController,
                        editProfileController, child) {
                  Userdata? userdata = studentParentTeacherController.userdata;
                  String? userRole = AppSharedPreferences.getUserLoggedInRole();
                  String? profileImage = userRole == "student"
                      ? userdata?.stuImage
                      : userRole == "parent"
                          ? userdata?.parentImage
                          : userdata?.teacherImage;
                  return Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: studentParentTeacherController
                                  .currentLoggedInUserRole ==
                              RoleType.parent
                          ? () async {
                              await editProfileController.pickProfilePicture();
                            }
                          : null,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.sizeOf(context).width * 0.01),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              // backgroundImage: NetworkImage(
                              //     "https://colegioatenea.es/wp-content/plugins/scl-rest-api/img/default_avtar.jpg"),
                              backgroundImage: editProfileController
                                          .pickImageFromFile ==
                                      null
                                  //     ? NetworkImage(
                                  //         profileImage ?? "https://colegioatenea.es/wp-content/plugins/scl-rest-api/img/default_avtar.jpg",
                                  // )
                                  ? CachedNetworkImageProvider(
                                      profileImage ??
                                          "https://colegioatenea.es/wp-content/plugins/scl-rest-api/img/default_avtar.jpg",
                                    )
                                  : FileImage(editProfileController
                                      .pickImageFromFile!) as ImageProvider,
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
              Consumer<EditProfileController>(
                builder: (context, editingController, child) {
                  return Visibility(
                      visible: editingController.isLoading,
                      child: LoadingLayout());
                },
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    emailController?.dispose();
    cityController?.dispose();
    mobileController?.dispose();
    actualAddressController?.dispose();
    postalCodeController?.dispose();
    nifController?.dispose();

    super.dispose();
  }
}
