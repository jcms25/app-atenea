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
                  Consumer<StoreController>(
                    builder: (context,storeController,child){
                      return Visibility(
                          visible: storeController.selectedPaymentMethod == "ppcp-gateway",
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                          child:  Column(
                            children: [
                              Text("\n- Cargo Fijo: 0.25\n- Cargo en Porcentaje: 3.5\n- Cargo mínimo: 0.5 \n- Cargo máximo: 0 (desactivado)\n- Impuestos incluidos",
                                style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.secondary),),
                              SizedBox(height: 10,),
                              Consumer<StoreController>(
                                builder: (context,storeController,child){
                                  // return Text("Total ${AppConstants.getTotalAmount(subTotal: AppConstants.formatPrice(double.tryParse('${storeController.cartResponse?.totals?.totalPrice ?? 0}') ?? 0))}",
                                  //   style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.secondary),
                                  // );
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total\t:",style: AppTextStyle.getOutfit600(textSize: 18, textColor: AppColors.black),),
                                      Text(AppConstants.formatPrice(double.tryParse(storeController.cartResponse?.totals?.totalPrice ?? "0.0") ?? 0.0),style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.secondary),)
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                          ));
                    },
                  ),
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
                    hintText:
                        """Añada las observaciones que crea oportunas para cuando procesemos el pedido (por ejemplo, entregar al alumno)""",
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
                               onPressed: () async {

                                 try {
                                  if (storeController.selectedPaymentMethod !=
                                      null) {


                                    // if(storeController
                                    //     .selectedPaymentMethod !=
                                    //     "ppcp-gateway"){
                                    //   storeController.setIsLoading(
                                    //       isLoading: true);
                                    //   dynamic orderAmount = int.parse(storeController.cartResponse?.totals?.totalPrice ?? "0");
                                    //
                                    //   dynamic result =
                                    //   await storeController.checkout(
                                    //       tiendaToken:
                                    //       studentParentTeacherController
                                    //           .userdata
                                    //           ?.tiendaToken ??
                                    //           "",
                                    //       wpUserId:
                                    //       studentParentTeacherController
                                    //           .userdata
                                    //           ?.parentWpUsrId ??
                                    //           "",
                                    //       additionalOrderComment:
                                    //       additionalComments?.text);
                                    //
                                    //   if (result['status']) {
                                    //     String orderId = result['orderId'];
                                    //
                                    //     await storeController
                                    //         .emptyCart(
                                    //         tiendaToken:
                                    //         studentParentTeacherController
                                    //             .userdata
                                    //             ?.tiendaToken ??
                                    //             "")
                                    //         .then((res) async {
                                    //
                                    //       if (storeController
                                    //           .selectedPaymentMethod ==
                                    //           "ppcp-gateway") {
                                    //
                                    //         //pay using paypal
                                    //         Get.back();
                                    //         await storeController.payUsingPaypal(
                                    //             orderId: orderId,
                                    //             wpUserId:
                                    //             studentParentTeacherController
                                    //                 .userdata
                                    //                 ?.parentWpUsrId ??
                                    //                 "",
                                    //             studentParentTeacherController:
                                    //             studentParentTeacherController,
                                    //             isFromCart: true,
                                    //             orderAmount: AppConstants.convertToPaypalAmount("$orderAmount")
                                    //         );
                                    //       } else if (storeController
                                    //           .selectedPaymentMethod ==
                                    //           "redsys") {
                                    //
                                    //         //RedSys Payment
                                    //         Get.back();
                                    //         await storeController.redSysPayment(paymentMethodType: "Redsys", orderId: orderId, amount: AppConstants.convertToPaypalAmount("$orderAmount"),wpUserId: studentParentTeacherController.userdata?.parentWpUsrId);
                                    //       } else if (storeController
                                    //           .selectedPaymentMethod ==
                                    //           "bizumredsys") {
                                    //
                                    //         //Bizum paypal
                                    //         Get.back();
                                    //         await storeController.redSysPayment(paymentMethodType: "Bizum", orderId: orderId, amount: AppConstants.convertToPaypalAmount("$orderAmount"),wpUserId: studentParentTeacherController.userdata?.parentWpUsrId);
                                    //
                                    //       } else {
                                    //         AppConstants.showCustomToast(
                                    //             status: false,
                                    //             message:
                                    //             "Por favor seleccione el método de pago");
                                    //       }
                                    //     });
                                    //   }
                                    //   else{
                                    //     AppConstants.showCustomToast(status: false, message: result['Message'] ?? result['message'] ?? "Error");
                                    //   }
                                    //
                                    //   storeController.setIsLoading(
                                    //       isLoading: false);
                                    // }else{
                                    //   AppConstants.showCustomToast(
                                    //       status: false,
                                    //       message:
                                    //       "Este método de pago no está disponible actualmente. Seleccione otro método de pago.");
                                    // }

                                    storeController.setIsLoading(
                                        isLoading: true);
                                    dynamic orderAmount = int.parse(storeController.cartResponse?.totals?.totalPrice ?? "0");

                                    dynamic result =
                                    await storeController.checkout(
                                        tiendaToken:
                                        studentParentTeacherController
                                            .userdata
                                            ?.tiendaToken ??
                                            "",
                                        wpUserId:
                                        studentParentTeacherController
                                            .userdata
                                            ?.parentWpUsrId ??
                                            "",
                                        additionalOrderComment:
                                        additionalComments?.text);

                                    if (result['status']) {
                                      String orderId = result['orderId'];

                                      await storeController
                                          .emptyCart(
                                          tiendaToken:
                                          studentParentTeacherController
                                              .userdata
                                              ?.tiendaToken ??
                                              "")
                                          .then((res) async {

                                        if (storeController
                                            .selectedPaymentMethod ==
                                            "ppcp-gateway") {

                                          //pay using paypal
                                          Get.back();
                                          await storeController.payUsingPaypal(
                                              orderId: orderId,
                                              wpUserId:
                                              studentParentTeacherController
                                                  .userdata
                                                  ?.parentWpUsrId ??
                                                  "",
                                              studentParentTeacherController:
                                              studentParentTeacherController,
                                              isFromCart: true,
                                              orderAmount: AppConstants.convertToPaypalAmount("$orderAmount")
                                          );
                                        } else if (storeController
                                            .selectedPaymentMethod ==
                                            "redsys") {

                                          //RedSys Payment
                                          Get.back();
                                          await storeController.redSysPayment(paymentMethodType: "Redsys", orderId: orderId, amount: AppConstants.convertToPaypalAmount("$orderAmount"),wpUserId: studentParentTeacherController.userdata?.parentWpUsrId);
                                        } else if (storeController
                                            .selectedPaymentMethod ==
                                            "bizumredsys") {

                                          //Bizum paypal
                                          Get.back();
                                          await storeController.redSysPayment(paymentMethodType: "Bizum", orderId: orderId, amount: AppConstants.convertToPaypalAmount("$orderAmount"),wpUserId: studentParentTeacherController.userdata?.parentWpUsrId);

                                        } else {
                                          AppConstants.showCustomToast(
                                              status: false,
                                              message:
                                              "Por favor seleccione el método de pago");
                                        }
                                      });
                                    }
                                    else{
                                      AppConstants.showCustomToast(status: false, message: result['Message'] ?? result['message'] ?? "Error");
                                    }

                                    storeController.setIsLoading(
                                        isLoading: false);

                                  } else {
                                    AppConstants.showCustomToast(
                                        status: false,
                                        message:
                                            "Por favor seleccione el método de pago");
                                  }



                                } catch (e) {
                                  AppConstants.showCustomToast(
                                      status: false, message: "$e");
                                  storeController.setIsLoading(
                                      isLoading: false);
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
        // FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;
        // print("Redsys is : ${firebaseRemoteConfig.getBool('enable_redsys')}" );
        // bool status = AppRemoteConfig.firebaseRemoteConfig?.getBool( paymentMethodName == "redsys"
        //     ? "enable_redsys"
        //     : paymentMethodName == "bizumredsys"
        //     ? "enable_bizum"
        //     : "enable_paypal") ?? false;
        // print(status);
        return GestureDetector(
          onTap: () {
            storeController.setSelectedPaymentMethod(
                selectedPaymentMethod: paymentMethodName);
            print(paymentMethodName);
          },
          child: Row(
            children: [
              Radio<String>(
                  activeColor: AppColors.primary,
                  value: paymentMethodName,
                  groupValue: storeController.selectedPaymentMethod,
                  onChanged: (String? value) {
                    storeController.setSelectedPaymentMethod(
                        selectedPaymentMethod: value);
                  }),
              Expanded(
                  child: Text(
                    paymentMethodName == "redsys"
                        ? "Servired/RedSys"
                        : paymentMethodName == "bizumredsys"
                        ? "Bizum"
                        : "PayPal",
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
