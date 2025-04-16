import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderNumber;

  const OrderDetailPage({super.key, required this.orderNumber});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  StoreController? storeController;
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res) {
      storeController = Provider.of<StoreController>(context, listen: false);
      storeController?.getOrderDetails(orderId: widget.orderNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          storeController?.setOrderDetailModel(orderDetailModel: null);
          storeController?.setIsLoading(isLoading: false);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            onLeadingIconClicked: () {
              storeController?.setOrderDetailModel(orderDetailModel: null);
              storeController?.setIsLoading(isLoading: false);
              Get.back();
            },
            title: Text(
              'Detalles del pedido - #${widget.orderNumber}',
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            ),
          ),
          body: Stack(
            children: [
              Consumer<StoreController>(
                builder: (context, storeController, child) {
                  return storeController.orderDetailModel == null
                      ? SizedBox.shrink()
                      : ScrollConfiguration(
                          behavior:
                              ScrollBehavior().copyWith(overscroll: false),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: AppColors.orange,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Text(
                                    "El pedido #${widget.orderNumber} se realizó el ${DateFormat("dd-MM-yyyy").format(DateTime.parse(storeController.orderDetailModel?.others?[0].date ?? ""))} y está actualmente ${storeController.orderDetailModel?.others?[0].status}",
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Table(
                                    border: TableBorder(
                                      verticalInside: BorderSide(
                                          color: AppColors.secondary, width: 1),
                                      horizontalInside: BorderSide(
                                          color: AppColors.secondary, width: 1),
                                      bottom: BorderSide(
                                          color: AppColors.secondary, width: 1),
                                      top: BorderSide(
                                          color: AppColors.secondary, width: 1),
                                      left: BorderSide(
                                          color: AppColors.secondary, width: 1),
                                      right: BorderSide(
                                          color: AppColors.secondary, width: 1),
                                    ),
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                            child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Producto",
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 16,
                                                  textColor: AppColors.white),
                                            ),
                                          ),
                                        )),
                                        TableCell(
                                            child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Total",
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 16,
                                                  textColor: AppColors.white),
                                            ),
                                          ),
                                        ))
                                      ]),
                                      ...storeController
                                              .orderDetailModel?.products
                                              ?.map((e) {
                                            return TableRow(children: [
                                              TableCell(
                                                  child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Center(
                                                  child: Text(
                                                    "${e.productName ?? ""} * ${e.quantity}",
                                                    style: AppTextStyle
                                                        .getOutfit400(
                                                            textSize: 16,
                                                            textColor: AppColors
                                                                .secondary),
                                                  ),
                                                ),
                                              )),
                                              TableCell(
                                                  child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Center(
                                                  child: Text(
                                                    "${e.total ?? ""}€",
                                                    style: AppTextStyle
                                                        .getOutfit400(
                                                            textSize: 16,
                                                            textColor: AppColors
                                                                .secondary),
                                                  ),
                                                ),
                                              )),
                                            ]);
                                          }) ??
                                          []
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(
                                    // color: AppColors.primary.withOpacity(0.05),
                                    color: AppColors.primary
                                        .withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      OrderDetailRow(
                                          label: "Subtotal",
                                          value:
                                              "${storeController.orderDetailModel?.others?[0].total}€"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      OrderDetailRow(
                                          label: "Métodos de pago	",
                                          value:
                                              "${storeController.orderDetailModel?.others?[0].paymentMethod}"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      OrderDetailRow(
                                          label: "Total",
                                          value:
                                              "${storeController.orderDetailModel?.others?[0].total}€"),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color:
                                      //     AppColors.primary.withOpacity(0.06)
                                      color: AppColors.primary
                                          .withValues(alpha: 0.06)),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dirección de facturación",
                                        style: AppTextStyle.getOutfit600(
                                            textSize: 20,
                                            textColor: AppColors.secondary),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        storeController
                                                .orderDetailModel?.billings
                                                ?.join("\n") ??
                                            "",
                                        style: AppTextStyle.getOutfit400(
                                            textSize: 16,
                                            textColor: AppColors.secondary),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: storeController.orderDetailModel?.others?[0].status == "pending" ? 80 : 0 ,
                                )
                              ],
                            ),
                          ));
                },
              ),
              Consumer<StoreController>(builder: (context,storeController,child){
                return  Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                      visible: storeController.orderDetailModel?.others?[0].status == "pending",
                      child: Padding(padding: const EdgeInsets.all(10), child:  Consumer2<StoreController, StudentParentTeacherController>(
                        builder: (context, storeController,
                            studentParentTeacherController, child) {
                          return Row(
                            children: [
                              Expanded(child: CustomButtonWidget(
                                  buttonTitle: 'Cancelar',
                                  onPressed: () async {
                                    await storeController.changeOrderStatus(
                                        orderId: widget.orderNumber,
                                        statusToChanged: 'cancelled',
                                        wpUserId: studentParentTeacherController
                                            .userdata?.wpUsrId ??
                                            "");
                                  })),
                              const SizedBox(width: 20,),
                              Expanded(child:   CustomButtonWidget(
                                  buttonTitle: 'Pagar', onPressed: () async{
                                  await storeController.getPaymentLinkForOrder(orderId: widget.orderNumber,isLoading: true);
                              }),)
                            ],
                          );
                        },
                      ),)),
                );
              }),
              Consumer<StoreController>(
                builder: (context, storeController, child) {
                  return Visibility(
                      visible: storeController.isLoading,
                      child: LoadingLayout());
                },
              )
            ],
          ),
        ));
  }
}

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const OrderDetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
          label,
          style: AppTextStyle.getOutfit500(
              textSize: 16, textColor: AppColors.secondary),
        )),
        Text(
          ":",
          style: AppTextStyle.getOutfit800(
              textSize: 16, textColor: AppColors.black),
        ),
        Expanded(
            child: Text(
          value,
          style: AppTextStyle.getOutfit400(
              textSize: 14, textColor: AppColors.secondary),
          textAlign: TextAlign.center,
        ))
      ],
    );
  }
}
