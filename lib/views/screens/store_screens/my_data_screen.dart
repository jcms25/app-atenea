import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/store_model/billing_detail_model.dart';

import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/utils/app_validations.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyDataScreen extends StatefulWidget {
  const MyDataScreen({super.key});

  @override
  State<MyDataScreen> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  StoreController? storeController;
  StudentParentTeacherController? studentParentTeacherController;

  TextEditingController? nameController,
      lastNameController,
      nifController,
      nifOptionalController,
      phoneController,
      addressController,
      postalCodeController,
      locationController,
      emailController,
      studentNameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    lastNameController = TextEditingController();
    nifController = TextEditingController();
    nifOptionalController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    postalCodeController = TextEditingController();
    locationController = TextEditingController();
    emailController = TextEditingController();
    studentNameController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((res) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      storeController = Provider.of<StoreController>(context, listen: false);
      storeController?.getBillingDetails(
          parentWpUserId:
              studentParentTeacherController?.userdata?.parentWpUsrId ?? "").then((res){
                BillingDetail? billingDetail = storeController?.billingDetail;
                nameController?.text = billingDetail?.billingFirstName ?? "";
                lastNameController?.text = billingDetail?.billingLastName ?? "";
                nifController?.text = billingDetail?.billingNIF ?? "";
                nifOptionalController?.text = billingDetail?.billingNIFOptional ?? "";
                phoneController?.text = billingDetail?.billingPhoneNumber ?? "";
                addressController?.text = billingDetail?.billingAddress1 ?? "";
                postalCodeController?.text = billingDetail?.billingPostcode ?? "";
                locationController?.text = billingDetail?.billingCity ?? "";
                emailController?.text = billingDetail?.billingEmail ?? "";
                studentNameController?.text = billingDetail?.billingAlumnosName ?? "";


      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (ctx, res) {
          storeController?.setIsOptional(isOptional: false);
          storeController?.setBillingDetailModel(billingDetail: null);
          storeController?.setListOfClass(classList: []);
          storeController?.setSelectedClassItem(selectedClassItem: null);
          storeController?.setSelectedProvince(selectedProvince: null);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
              onLeadingIconClicked: () {
                storeController?.setIsOptional(isOptional: false);
                storeController?.setBillingDetailModel(billingDetail: null);
                storeController?.setListOfClass(classList: []);
                storeController?.setSelectedClassItem(selectedClassItem: null);
                storeController?.setSelectedProvince(selectedProvince: null);
                Get.back();
              },
              title: Text(
                'Mis Datos',
                style: AppTextStyle.getOutfit500(
                    textSize: 20, textColor: AppColors.white),
              )),
          body: Stack(
            children: [
              ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                          key: globalKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                  controller: nameController,
                                  label: "Nombre",
                                  validateFunction:
                                      AppValidations.valueEmptyOrNot),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                 controller: lastNameController,
                                  label: "Appellidos",
                                  validateFunction:
                                      AppValidations.valueEmptyOrNot),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                 controller: nifController,
                                  label: "NIF",
                                  validateFunction:
                                      AppValidations.valueEmptyOrNot),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                controller: nifOptionalController,
                                  label: "NIF (opcional)",
                                  validateFunction: (String? value) {}),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                controller: phoneController,
                                  label: "Telefono",
                                  validateFunction:
                                      AppValidations.valueEmptyOrNot),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                controller: addressController,
                                  label: "Dirección",
                                  validateFunction:
                                      AppValidations.valueEmptyOrNot),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                  controller: postalCodeController,
                                  label: "Codigo postal (opcional) ",
                                  validateFunction: (String? value) {}),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                  controller: locationController,
                                  label: "Localidad (opcional)",
                                  validateFunction: (String? value) {}),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Provincia (opcional)",
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 18,
                                      textColor: AppColors.secondary)),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                    // color:
                                    // AppColors.secondary.withOpacity(0.05),
                                    color: AppColors.secondary.withValues(alpha: 0.05),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Center(
                                  child: Consumer<StoreController>(
                                    builder: (context, storeController, child) {
                                      return DropdownButton<String>(
                                          value: storeController.selectedProvince,
                                          hint: Text(
                                            'Seleccionar Provincia',
                                            style: AppTextStyle.getOutfit400(
                                                textSize: 16,
                                                // textColor: AppColors.secondary
                                                //     .withOpacity(0.4)
                                                textColor: AppColors.secondary.withValues(alpha: 0.4)
                                            ),
                                          ),
                                          items: AppConstants.spainProvince
                                              .map((e) {
                                            return DropdownMenuItem<String>(
                                                value: e,
                                                child: Text(
                                                  e,
                                                  style: AppTextStyle
                                                      .getOutfit400(
                                                      textSize: 18,
                                                      textColor: AppColors
                                                          .secondary),
                                                ));
                                          }).toList(),
                                          underline: const SizedBox.shrink(),
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            storeController.setSelectedProvince(selectedProvince: value);
                                          });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("País",
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 18,
                                      textColor: AppColors.secondary)),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    // color:
                                    //     AppColors.secondary.withOpacity(0.1)
                                  color: AppColors.secondary.withValues(alpha: 0.1)
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('España',
                                      style: AppTextStyle.getOutfit400(
                                          textSize: 18,
                                          textColor: AppColors.secondary)),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                 controller: emailController,
                                  label: "Correo electrónico",
                                  validateFunction:
                                      AppValidations.valueEmptyOrNot),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                controller: studentNameController,
                                  label: "Nombre alumno",
                                  validateFunction:
                                      AppValidations.valueEmptyOrNot),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Curso",
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 18,
                                      textColor: AppColors.secondary)),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                    // color:
                                    //     AppColors.secondary.withOpacity(0.05),
                                    color: AppColors.secondary.withValues(alpha: 0.05),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Center(
                                  child: Consumer<StoreController>(
                                    builder: (context, storeController, child) {
                                      return DropdownButton<String>(
                                          value: storeController.selectedClassItem,
                                          hint: Text(
                                                storeController.selectedClassItem?.isEmpty ?? false ? 'Seleccionar clase' : storeController.selectedClassItem ?? "",
                                            style: AppTextStyle.getOutfit400(
                                                textSize: 16,
                                                // textColor: AppColors.secondary
                                                //     .withOpacity(0.4)
                                              textColor: AppColors.secondary.withValues(alpha: 0.4)
                                            ),
                                          ),
                                          items: storeController.classList
                                              .map((e) {
                                            return DropdownMenuItem<String>(
                                                value: e.cName ?? "",
                                                child: Text(
                                                  "${e.cName}",
                                                  style: AppTextStyle
                                                      .getOutfit400(
                                                      textSize: 18,
                                                      textColor: AppColors
                                                          .secondary),
                                                ),
                                                // child: Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.start,
                                                //   children: [
                                                //     Consumer<StoreController>(
                                                //       builder: (context,
                                                //           storeController,
                                                //           child) {
                                                //         return Checkbox(
                                                //             value: s,
                                                //             onChanged:
                                                //                 (bool? status) {
                                                //               if (status ??
                                                //                   false) {
                                                //                 storeController
                                                //                     .addToSelectedClassItem(
                                                //                         className:
                                                //                             e.cName ??
                                                //                                 "");
                                                //               } else {
                                                //                 storeController
                                                //                     .removeSelectedClassItem(
                                                //                         className:
                                                //                             e.cName ??
                                                //                                 "");
                                                //               }
                                                //             });
                                                //       },
                                                //     ),
                                                //
                                                //   ],
                                                // ));
                                            );
                                          }).toList(),
                                          underline: const SizedBox.shrink(),
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            storeController.setSelectedClassItem(selectedClassItem: value);
                                          });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Consumer2<StoreController,StudentParentTeacherController>(
                                builder: (context, storeController, studentParentTeacherController,child) {
                                  return CustomButtonWidget(
                                      buttonTitle: 'Guardar Dirección',
                                      onPressed: () async{
                                        if (globalKey.currentState
                                                ?.validate() ??
                                            false) {
                                          await storeController.editBillingDetails(
                                              wpUserId: studentParentTeacherController.userdata?.parentWpUsrId ?? "",
                                              billingName: nameController?.text ?? "",
                                              billingLastName: lastNameController?.text ?? "",
                                               billingNIF: nifController?.text ?? "",
                                              billingNIFOptional: nifOptionalController?.text ?? "",
                                              billingPhoneNumber: phoneController?.text ?? "",
                                              billingAddress: addressController?.text ?? "",
                                              billingPostCode: postalCodeController?.text ?? "",
                                              billingCity: locationController?.text ?? "",
                                              billingState: storeController.selectedProvince ?? "",
                                              billingEmail: emailController?.text ?? "",
                                              billingAlumnosName: studentNameController?.text ?? "",
                                              billingAlumnosClass: storeController.selectedClassItem ?? "");
                                        }
                                      });
                                },
                              )
                            ],
                          )),
                    ),
                  )),
              Consumer<StoreController>(
                  builder: (context, storeController, child) {
                return Visibility(
                    visible: storeController.isLoading, child: LoadingLayout());
              })
            ],
          ),
        ));
  }

  @override
  void dispose() {
    if(!mounted){
      nameController?.dispose();
      lastNameController?.dispose();
      nifController?.dispose();
      nifOptionalController?.dispose();
      phoneController?.dispose();
      locationController?.dispose();
      postalCodeController?.dispose();
      emailController?.dispose();
    }
    super.dispose();
  }
}
