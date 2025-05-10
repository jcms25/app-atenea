import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_textstyle.dart';

class CheckOutBottomSheet extends StatefulWidget {
  const CheckOutBottomSheet({super.key});

  @override
  State<CheckOutBottomSheet> createState() => _CheckOutBottomSheetState();
}

class _CheckOutBottomSheetState extends State<CheckOutBottomSheet> {
  StoreController? storeController;
  StudentParentTeacherController? studentParentTeacherController;

  TextEditingController? additionalComments;

  @override
  void initState() {
    super.initState();
    storeController = Provider.of<StoreController>(context, listen: false);
    studentParentTeacherController =
        Provider.of<StudentParentTeacherController>(context, listen: false);
    additionalComments = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: !(storeController?.isLoading ?? false),
        onPopInvokedWithResult: (res, ctx) {},
        child: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: AppColors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Consumer<StoreController>(
                        builder: (context, storeController, child) {
                          return IconButton(
                              onPressed: !(storeController.isLoading)
                                  ? () {
                                      Get.back();
                                    }
                                  : null,
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColors.primary,
                              ));
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Verificar',
                        style: AppTextStyle.getOutfit600(
                            textSize: 20, textColor: AppColors.primary),
                      )
                    ],
                  ),
                  ...storeController?.cartResponse?.paymentMethods?.map((e) {
                        return PaymentOptionWidget(paymentMethodName: e);
                      }) ??
                      [],
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Observaciones del pedido:',
                    style: AppTextStyle.getOutfit400(
                        textSize: 20, textColor: AppColors.secondary),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    validateFunction: (value) {},
                    minLine: 5,
                    controller: additionalComments,
                    textInputAction: TextInputAction.done,
                    hintText: """Añada las observaciones que crea oportunas para cuando procesemos el pedido (por ejemplo, entregar al alumno)""",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer2<StoreController, StudentParentTeacherController>(
                    builder: (context, storeController,
                        studentParentTeacherController, child) {
                      return storeController.isBottomSheetLoader
                          ? Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : CustomButtonWidget(
                              margin: 10,
                              backgroundColor: AppColors.orange,
                              textColor: AppColors.secondary,
                              buttonTitle: 'Realizar el pedido',
                              onPressed: () async{



                                // if(storeController.selectedPaymentMethod == "ppcp-gateway") {
                                if(storeController.selectedPaymentMethod != null) {
                                  if(storeController.selectedPaymentMethod == "ppcp-gateway"){
                                    try {
                                      storeController.setIsLoading(
                                          isLoading: true);


                                      if (storeController.selectedPaymentMethod !=
                                          null) {
                                        dynamic result = await storeController.checkout(
                                          tiendaToken:
                                          studentParentTeacherController
                                              .userdata?.tiendaToken ??
                                              "",
                                          additionalOrderComment: additionalComments?.text.isNotEmpty ?? false ? additionalComments?.text ?? "" : null,
                                          wpUserId: studentParentTeacherController.userdata?.parentWpUsrId ?? "",
                                        );

                                        if(result['status']){

                                          String orderId = result['orderId'];
                                          await storeController.payUsingPaypal(orderId: orderId, wpUserId: studentParentTeacherController.userdata?.parentWpUsrId ?? "",isFromCart: true,studentParentTeacherController: studentParentTeacherController);

                                        }else{
                                          storeController.setIsLoading(isLoading: false);
                                        }
                                      } else {
                                        AppConstants.showCustomToast(status: false, message: 'Por favor seleccione el método de pago');
                                      }

                                      storeController.setIsLoading(
                                          isLoading: false);
                                    } catch (exception) {
                                      storeController.setIsLoading(
                                          isLoading: false);
                                      AppConstants.showCustomToast(
                                          status: false, message: "$exception");
                                    }
                                  }else{

                                  }

                                } else {
                                  AppConstants.showCustomToast(status: false, message: 'Por favor seleccione el método de pago');
                                }

                              });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class PaymentOptionWidget extends StatelessWidget {
  final String paymentMethodName;

  const PaymentOptionWidget({super.key, required this.paymentMethodName});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreController>(
      builder: (context, storeController, child) {
        return GestureDetector(
          onTap: () {
            // storeController.setSelectedPaymentOption(
            //     selectedPaymentOption: paymentMethodName);
            storeController.setSelectedPaymentMethod(
                selectedPaymentMethod: paymentMethodName);
          },
          child: Row(
            children: [
              Radio<String>(
                  value: paymentMethodName,
                  groupValue: storeController.selectedPaymentMethod,
                  onChanged: (String? value) {
                    // storeController.setSelectedPaymentOption(
                    //     selectedPaymentOption: value);

                    storeController.setSelectedPaymentMethod(
                        selectedPaymentMethod: value);
                  }),
              Expanded(
                  child: Text(
                paymentMethodName == "redsys" ? "Servired/RedSys" : paymentMethodName == "bizumredsys" ? "Bizum" : "PayPal",
                style: AppTextStyle.getOutfit500(
                    textSize: 18, textColor: AppColors.secondary),
              ))
            ],
          ),
        );
      },
    );
  }
}
