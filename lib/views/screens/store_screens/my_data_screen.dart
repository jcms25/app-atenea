import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/utils/app_validations.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyDataScreen extends StatelessWidget {
  MyDataScreen({super.key});
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final storeController =
        Provider.of<StoreController>(context, listen: false);
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (ctx, res) {
          storeController.setIsOptional(isOptional: false);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
              onLeadingIconClicked: () {
                storeController.setIsOptional(isOptional: false);
                Get.back();
              },
              title: Text(
                'Mis Datos',
                style: AppTextStyle.getOutfit500(
                    textSize: 20, textColor: AppColors.white),
              )),
          body: ScrollConfiguration(
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
                          label: "Nombre",
                          validateFunction: AppValidations.valueEmptyOrNot),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "Appellidos",
                          validateFunction: AppValidations.valueEmptyOrNot),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "NIF", validateFunction: AppValidations.valueEmptyOrNot),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "NIF (opcional)",
                          validateFunction: (String? value) {}),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "Telefono",
                          validateFunction: AppValidations.valueEmptyOrNot),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "Dirección",
                          validateFunction: AppValidations.valueEmptyOrNot),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "Codigo postal (opcional) ",
                          validateFunction: (String? value) {}),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "Localidad (opcional)",
                          validateFunction: (String? value) {}),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "Provincia (opcional)",
                          validateFunction: (String? value) {}),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("País",
                          style: AppTextStyle.getOutfit400(
                              textSize: 18, textColor: AppColors.secondary)),
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
                            color: AppColors.secondary.withOpacity(0.1)),
                        padding: const EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('India',
                              style: AppTextStyle.getOutfit400(
                                  textSize: 18,
                                  textColor: AppColors.secondary)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "Correo electrónico",
                          validateFunction: AppValidations.valueEmptyOrNot),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          label: "Nombre alumno",
                          validateFunction:  AppValidations.valueEmptyOrNot),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Curso",
                          style: AppTextStyle.getOutfit400(
                              textSize: 18, textColor: AppColors.secondary)),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.05),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Center(
                          child: DropdownButton<String>(
                              value: null,
                              items: AppConstants.roleDropDown.map((e) {
                                return DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: AppTextStyle.getOutfit400(
                                          textSize: 18,
                                          textColor: AppColors.secondary),
                                    ));
                              }).toList(),
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              onChanged: (String? value) {}),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Consumer<StoreController>(
                            builder: (context, storeController, child) {
                              return Checkbox(
                                  value: storeController.isOptional,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  onChanged: (bool? value) {
                                    storeController.setIsOptional(
                                        isOptional: value ?? false);
                                  });
                            },
                          ),
                          Expanded(
                              child: Text(
                                "Actualizar esta dirección también para mis suscripciones. (opcional)",
                                style: AppTextStyle.getOutfit400(
                                    textSize: 14, textColor: AppColors.secondary),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer<StoreController>(
                        builder: (context, storeController, child) {
                          return CustomButtonWidget(
                              buttonTitle: 'Guardar Dirección',
                              onPressed: () {
                                if(globalKey.currentState?.validate() ?? false){

                                }
                              });
                        },
                      )
                    ],
                  )),
                ),
              )),
        ));
  }
}
