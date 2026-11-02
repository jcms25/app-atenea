import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
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

  List<Map<String, dynamic>> hijosReserva = [];
  Set<int> alumnosElegidos = {};
  bool cargandoHijosReserva = false;

  // Nº de unidades de reserva en el carrito (el servidor marca cada línea con es_reserva)
  int get reservasEnCarrito {
    final items = storeController?.cartResponse?.items;
    if (items == null) return 0;
    int n = 0;
    for (final item in items) {
      if (item.extensions?.esReserva == true) {
        n += item.quantity ?? 0;
      }
    }
    return n;
  }

  @override
  void initState() {
    super.initState();
    storeController = Provider.of<StoreController>(context, listen: false);
    studentParentTeacherController =
        Provider.of<StudentParentTeacherController>(context, listen: false);
    additionalComments = TextEditingController();
    if (reservasEnCarrito > 0) {
      _cargarHijosReserva();
    }
  }

  Future<void> _cargarHijosReserva() async {
    setState(() => cargandoHijosReserva = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final userdata = AppSharedPreferences.getUserData();
      final response = await ApiClass().getReservasMisHijos(
        token: token,
        cookie: userdata?.cookies ?? '',
        parentWpUsrId: userdata?.parentWpUsrId ?? '',
      );
      if (response['status'] == true) {
        final hijos = (response['hijos'] as List<dynamic>)
            .map((h) => Map<String, dynamic>.from(h as Map))
            .toList();
        if (!mounted) return;
        setState(() {
          hijosReserva = hijos;
          if (hijos.length == reservasEnCarrito) {
            alumnosElegidos = hijos.map((h) => h['id'] as int).toSet();
          }
        });
      }
    } finally {
      if (mounted) setState(() => cargandoHijosReserva = false);
    }
  }

  Widget _selectorAlumnosReserva() {
    final reservas = reservasEnCarrito;
    if (reservas == 0) return const SizedBox.shrink();
    if (cargandoHijosReserva) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: LinearProgressIndicator(),
      );
    }
    final fijos = hijosReserva.length == reservas;
    final masReservasQueHijos = reservas > hijosReserva.length;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alumno/a de la reserva',
            style: AppTextStyle.getOutfit600(
                textSize: 18, textColor: AppColors.primary),
          ),
          const SizedBox(height: 6),
          if (masReservasQueHijos)
            Text(
              'Has añadido $reservas reservas, pero tienes ${hijosReserva.length} alumno(s) registrado(s). Reduce la cantidad en el carrito: solo se puede reservar una plaza por alumno.',
              style: AppTextStyle.getOutfit400(
                  textSize: 16, textColor: Colors.red),
            )
          else ...[
            Text(
              fijos
                  ? 'La reserva corresponde a:'
                  : 'Marca exactamente $reservas alumno(s) a quien corresponde la reserva:',
              style: AppTextStyle.getOutfit400(
                  textSize: 16, textColor: AppColors.secondary),
            ),
            ...hijosReserva.map((h) {
              final id = h['id'] as int;
              final marcado = alumnosElegidos.contains(id);
              final bloqueado =
                  fijos || (!marcado && alumnosElegidos.length >= reservas);
              return CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('${h['nombre']}'),
                value: marcado,
                onChanged: bloqueado
                    ? null
                    : (v) {
                        setState(() {
                          if (v == true) {
                            alumnosElegidos.add(id);
                          } else {
                            alumnosElegidos.remove(id);
                          }
                        });
                      },
              );
            }),
          ],
        ],
      ),
    );
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
                  _selectorAlumnosReserva(),
                  ...storeController?.cartResponse?.paymentMethods?.map((e) {
                        return PaymentOptionWidget(paymentMethodName: e);
                      }) ??
                      [],
                  Consumer<StoreController>(
                    builder: (context, storeController, child) {
                      return Visibility(
                          visible: storeController.selectedPaymentMethod ==
                              "ppcp-gateway",
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Text(
                                  "\n- Cargo Fijo: 0.25\n- Cargo en Porcentaje: 3.5\n- Cargo mínimo: 0.5 \n- Cargo máximo: 0 (desactivado)\n- Impuestos incluidos",
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 18,
                                      textColor: AppColors.secondary),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Consumer<StoreController>(
                                  builder: (context, storeController, child) {
                                    // return Text("Total ${AppConstants.getTotalAmount(subTotal: AppConstants.formatPrice(double.tryParse('${storeController.cartResponse?.totals?.totalPrice ?? 0}') ?? 0))}",
                                    //   style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.secondary),
                                    // );
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total\t:",
                                          style: AppTextStyle.getOutfit600(
                                              textSize: 18,
                                              textColor: AppColors.black),
                                        ),
                                        Text(
                                          AppConstants.formatPrice(
                                              double.tryParse(storeController
                                                          .cartResponse
                                                          ?.totals
                                                          ?.totalPrice ??
                                                      "0.0") ??
                                                  0.0),
                                          style: AppTextStyle.getOutfit400(
                                              textSize: 18,
                                              textColor: AppColors.secondary),
                                        )
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
                                final reservas = reservasEnCarrito;
                                if (reservas > hijosReserva.length) {
                                  AppConstants.showCustomToast(
                                      status: false,
                                      message:
                                          'El número de reservas no coincide con el número de hijos matriculados en el centro. Reduce la cantidad en el carrito.');
                                  return;
                                }
                                if (reservas > 0 &&
                                    alumnosElegidos.length != reservas) {
                                  AppConstants.showCustomToast(
                                      status: false,
                                      message:
                                          'Selecciona exactamente $reservas alumno(s) para la reserva.');
                                  return;
                                }
                                try {
                                  if (storeController.selectedPaymentMethod !=
                                      null) {
                                    storeController.setIsLoading(
                                        isLoading: true);
                                    dynamic orderAmount = int.parse(
                                        storeController.cartResponse?.totals
                                                ?.totalPrice ??
                                            "0");
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
                                                additionalComments?.text,
                                            alumnosReserva:
                                                alumnosElegidos.toList());

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
                                              orderAmount: AppConstants
                                                  .convertToPaypalAmount(
                                                      "$orderAmount"));
                                        } else if (storeController
                                                .selectedPaymentMethod ==
                                            "redsys") {
                                          //RedSys Payment
                                          Get.back();
                                          await storeController.redSysPayment(
                                              paymentMethodType: "Redsys",
                                              orderId: orderId,
                                              amount: AppConstants
                                                  .convertToPaypalAmount(
                                                      "$orderAmount"),
                                              wpUserId:
                                                  studentParentTeacherController
                                                      .userdata?.parentWpUsrId);
                                        } else if (storeController
                                                .selectedPaymentMethod ==
                                            "bizumredsys") {
                                          //Bizum paypal
                                          Get.back();
                                          await storeController.redSysPayment(
                                              paymentMethodType: "Bizum",
                                              orderId: orderId,
                                              amount: AppConstants
                                                  .convertToPaypalAmount(
                                                      "$orderAmount"),
                                              wpUserId:
                                                  studentParentTeacherController
                                                      .userdata?.parentWpUsrId);
                                        } else if (storeController
                                                .selectedPaymentMethod ==
                                            "bacs") {
                                          // Transferencia bancaria: sin pago online.
                                          // El pedido queda en 'on-hold'. Avisamos al padre.
                                          Get.back(); // cierra el bottom sheet
                                          await Get.dialog(
                                            AlertDialog(
                                              title: const Text('Reserva registrada'),
                                              content: const Text(
                                                  'Su reserva se ha registrado correctamente.\n\n'
                                                  'Recibirá por correo electrónico los datos bancarios para realizar la transferencia.\n\n'
                                                  'Una vez hecha, podrá subir el justificante desde "Mis Compras Atenea".'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text('Entendido'),
                                                ),
                                              ],
                                            ),
                                            barrierDismissible: false,
                                          );
                                        } else {
                                          AppConstants.showCustomToast(
                                              status: false,
                                              message:
                                                  "Por favor seleccione el método de pago");
                                        }
                                      });
                                    } else {
                                      if (result['message'] == null) {
                                        AppConstants.showCustomToast(
                                            status: false,
                                            message: "Error al procesar el pedido");
                                      }
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
                        : paymentMethodName == "bacs"
                            ? "Transferencia bancaria"
                            : paymentMethodName,
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
