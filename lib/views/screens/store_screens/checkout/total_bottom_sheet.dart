import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/store_screens/checkout/checkout_bottom_sheet.dart';
import 'package:colegia_atenea/views/screens/store_screens/checkout/coupon_list_bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../custom_widgets/custom_button_widget.dart';

class TotalBottomSheet extends StatefulWidget {
  const TotalBottomSheet({super.key});

  @override
  State<TotalBottomSheet> createState() => _TotalBottomSheetState();
}

class _TotalBottomSheetState extends State<TotalBottomSheet> {
  StoreController? storeController;
  StudentParentTeacherController? studentParentTeacherController;

  // TextEditingController? couponController;

  @override
  void initState() {
    super.initState();
    storeController = Provider.of<StoreController>(context, listen: false);
    studentParentTeacherController =
        Provider.of<StudentParentTeacherController>(context, listen: false);
    // couponController = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: !(storeController?.isBottomSheetLoader ?? false),
        child:  SingleChildScrollView(child: Consumer<StoreController>(
            builder: (context, storeController, child) {
              return Container(
                height: MediaQuery.sizeOf(context).height * 0.75,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Totales del carrito",
                              style: AppTextStyle.getOutfit600(
                                  textSize: 24, textColor: AppColors.secondary),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.cancel))
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildTotalRow(
                            'Subtotal',
                            // '${storeController.cartResponse?.totals?.totalPrice ?? 0}'
                            AppConstants.formatPrice((double.tryParse(
                                "${storeController.cartResponse?.totals?.totalItems}") ??
                                0.0) +
                                (double.tryParse(
                                    "${storeController.cartResponse?.totals?.totalItemsTax}") ??
                                    0.0))),
                        const SizedBox(
                          height: 10,
                        ),
                        ...storeController.cartResponse?.coupons?.map((coupon) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Cupón:\n${coupon.code ?? ""}',
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 18, textColor: AppColors.secondary)),
                                RichText(text: TextSpan(
                                    text: "-${AppConstants.formatPrice((double.tryParse(coupon.totals?.totalDiscount ?? "") ?? 0) + (double.tryParse(coupon.totals?.totalDiscountTax ?? "") ?? 0))}",
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 18, textColor: AppColors.secondary),
                                    children: [
                                      TextSpan(
                                        text: "[Eliminar]",
                                        style: AppTextStyle.getOutfit500(
                                            textSize: 18, textColor: AppColors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await storeController.applyOrRemoveCoupon(
                                                applyOrRemove: 1,
                                                couponCode: coupon.code ?? "",
                                                tiendaToken: studentParentTeacherController?.userdata?.tiendaToken ?? "");
                                          },
                                      )
                                    ]
                                )),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        )) ?? [],

                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(height: 16, color: AppColors.secondary),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTotalRow(
                            'Total',
                            // '${storeController.cartResponse?.totals?.totalPrice ?? 0}'
                            "${AppConstants.formatPrice(double.tryParse('${storeController.cartResponse?.totals?.totalPrice ?? 0}') ?? 0)}\t${storeController.cartResponse?.totals?.taxLines != null ? "(incluye ${storeController.cartResponse?.totals?.taxLines?.map((item) {
                              return "${AppConstants.formatPrice(double.tryParse(item.price ?? "0") ?? 0)}\t${item.name}";
                            }).toList().join(",")})" : ""}"),
                        // const Spacer(),
                        // Consumer2<StoreController,StudentParentTeacherController>(
                        //   builder: (context,storeController,studentParentTeacherController,child){
                        //     CouponListResponse? couponListResponse = storeController.couponListResponse;
                        //     return Visibility(
                        //       visible: couponListResponse != null,
                        //       child: GestureDetector(
                        //         onTap: (){
                        //           couponController?.text = couponListResponse?.code ?? "";
                        //         },
                        //         child:  Container(
                        //           padding: const EdgeInsets.all(10),
                        //           width: MediaQuery.sizeOf(context).width,
                        //           decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(10),
                        //               color: AppColors.primary
                        //           ),
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Column(
                        //                     mainAxisAlignment: MainAxisAlignment.start,
                        //                     children: [
                        //                       Text(couponListResponse?.discountType == "percent" ? "${double.parse(couponListResponse?.amount ?? "0.0").toInt()}\t%" : "${couponListResponse?.amount ?? ""}\t€",style: AppTextStyle.getOutfit600(textSize: 30, textColor: AppColors.orange),),
                        //                       const SizedBox(height: 5,),
                        //                       Text('DESCUENTO',style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.white),)
                        //                     ],
                        //                   ),
                        //                   const SizedBox(width: 10,),
                        //                   Expanded(child: Text(
                        //                     // "Descuento del 10% en Uniformes y Ropa deportiva por pertenecer a la AMPA",
                        //                     couponListResponse?.description ?? "",
                        //                     textAlign: TextAlign.start,
                        //                     style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.orange),))
                        //                 ],
                        //               ),
                        //               const SizedBox(height: 20,),
                        //               Row(
                        //                 children: [
                        //                   Expanded(child: Row(
                        //                     children: [
                        //                       Icon(Icons.discount,color: AppColors.orange,),
                        //                       SizedBox(width: 5,),
                        //                       Text("${couponListResponse?.code}",style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.orange),)
                        //                     ],
                        //                   )),
                        //                   const SizedBox(width: 5,),
                        //                   Expanded(child: Row(
                        //                     children: [
                        //                       Icon(Icons.watch_later_outlined,color: AppColors.orange,),
                        //                       SizedBox(width: 5,),
                        //                       Text("Nunca caduca",style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.orange),)
                        //                     ],
                        //                   ))
                        //                 ],
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // TextField inside Expanded to take available space
                            // Expanded(
                            //   flex: 2,
                            //   child: SizedBox(
                            //     height: 60,
                            //     child: TextField(
                            //       controller: couponController,
                            //       decoration: InputDecoration(
                            //         hintText: 'Ingrese su cupón',
                            //         // Placeholder text
                            //         border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(8.0),
                            //         ),
                            //         contentPadding:
                            //         const EdgeInsets.symmetric(horizontal: 12.0),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(width: 10),
                            // Space between TextField and Button

                            // Button inside Expanded to avoid overflow
                            // Expanded(
                            //   flex: 1,
                            //   child: ElevatedButton(
                            //     onPressed: () async {
                            //       // Implement coupon apply logic
                            //       if(couponController?.text.isNotEmpty ?? false || couponController?.text.trim() != ""){
                            //         await storeController.applyOrRemoveCoupon(
                            //             applyOrRemove: 0,
                            //             couponCode: couponController?.text ?? "",
                            //             tiendaToken: studentParentTeacherController
                            //                 ?.userdata?.tiendaToken ??
                            //                 "").then((res){
                            //           couponController?.clear();
                            //         });
                            //       }else{
                            //         AppConstants.showCustomToast(status: false, message: "Por favor ingrese el código de cupón válido");
                            //       }
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       padding:
                            //       const EdgeInsets.symmetric(vertical: 16.0),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(8.0),
                            //       ),
                            //     ),
                            //     child: Text(
                            //       'APLICAR CUPÓN',
                            //       textAlign: TextAlign.center,
                            //       style: const TextStyle(
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // )

                            ElevatedButton(
                              onPressed: () async {
                                // Implement coupon apply logic
                                // if(couponController?.text.isNotEmpty ?? false || couponController?.text.trim() != ""){
                                //   await storeController.applyOrRemoveCoupon(
                                //       applyOrRemove: 0,
                                //       couponCode: couponController?.text ?? "",
                                //       tiendaToken: studentParentTeacherController
                                //           ?.userdata?.tiendaToken ??
                                //           "").then((res){
                                //     couponController?.clear();
                                //   });
                                // }else{
                                //   AppConstants.showCustomToast(status: false, message: "Por favor ingrese el código de cupón válido");
                                // }
                                Get.bottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: AppColors.transparent,
                                    CouponListBottomSheet()).then((res){
                                  //this is after bottom sheet closed
                                  storeController.setCouponListResponse(couponListResponse: []);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 16.0,horizontal: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                'APLICAR CUPÓN',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<StoreController>(
                          builder: (context, storeController, child) {
                            return CustomButtonWidget(
                              buttonTitle: 'Finalizar compra',
                              onPressed: storeController.isBottomSheetLoader ? null : (){
                                Get.back();
                                Get.bottomSheet(
                                    isScrollControlled: true,
                                    isDismissible: !(storeController.isLoading),
                                    CheckOutBottomSheet(),
                                    backgroundColor: AppColors.transparent
                                ).then((res){
                                  storeController.setSelectedPaymentMethod(selectedPaymentMethod: null);
                                });
                              },
                              backgroundColor: AppColors.orange,
                              textColor: AppColors.secondary,
                            );
                          },
                        )
                      ],
                    ),
                    Visibility(
                        visible: storeController.isBottomSheetLoader,
                        child: LoadingLayout(
                          backgroundColor: AppColors.transparent,
                        ))
                  ],
                ),
              );
            }),),);
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyle.getOutfit500(
                textSize: 18, textColor: AppColors.secondary)),
        Text(value,
            style: AppTextStyle.getOutfit500(
                textSize: 18, textColor: AppColors.secondary)),
      ],
    );
  }

  @override
  void dispose() {
    // if (!mounted) {
    //   couponController?.dispose();
    // }
    super.dispose();
  }
}
