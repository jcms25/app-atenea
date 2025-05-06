import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/store_model/coupon_response.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {

  StoreController? storeController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res){
        storeController = Provider.of<StoreController>(context,listen: false);
        storeController?.getCoupons();
    });
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          storeController?.setCouponListResponse(couponListResponse: null);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
              onLeadingIconClicked: (){
                storeController?.setCouponListResponse(couponListResponse: null);
                Get.back();
              },
              title: Text('Cupones',
                  style: AppTextStyle.getOutfit600(
                    textSize: 20,
                    textColor: AppColors.white,
                  ))),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20)),
                      child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Notas\t:\t",
                                style: AppTextStyle.getOutfit500(
                                    textSize: 20, textColor: AppColors.primary),
                                children: [
                                  TextSpan(
                                      text:
                                      "\n\nLista de cupones válidos y disponibles para su uso. Haga clic en el cupón para utilizarlo. El cupón de descuento sólo será visible cuando haya al menos un producto en la cesta.",
                                      style: AppTextStyle.getOutfit400(
                                          textSize: 16, textColor: AppColors.secondary))
                                ])
                          ])),
                    ),
                    const SizedBox(height: 20,),


                    Text('Cupones Disponibles',style: AppTextStyle.getOutfit500(textSize: 24, textColor: AppColors.secondary),),
                    const SizedBox(height: 20,),

                    Consumer2<StoreController,StudentParentTeacherController>(
                      builder: (context,storeController,studentParentTeacherController,child){
                        CouponListResponse? couponListResponse = storeController.couponListResponse;
                        return Visibility(
                          visible: couponListResponse != null,
                          child: GestureDetector(
                            onTap: (){
                              Get.dialog(
                              barrierDismissible: true,

                                  AlertDialog(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                                 title: Text('Aplicar cupón',style: AppTextStyle.getOutfit600(textSize: 22, textColor: AppColors.secondary),),
                                 content: Text('¿Quieres aplicar un cupón con el código de cupón: ${couponListResponse?.code} ?'),
                                 actions: [
                                   CustomButtonWidget(buttonTitle: 'No', onPressed: (){
                                     Get.back();
                                   } ),
                                   const SizedBox(height: 10,),
                                   CustomButtonWidget(buttonTitle: 'Sí', onPressed: () async{

                                     Get.back();
                                     await storeController.applyOrRemoveCoupon(applyOrRemove: 0, couponCode: couponListResponse?.code ?? "", tiendaToken: studentParentTeacherController.userdata?.tiendaToken ?? "").then((res){
                                            storeController.setIsBottomSheetLoader(isBottomSheetLoader: false);
                                     });
                                   } )
                                 ],
                              ));
                            },
                            child:  Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.primary
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          // Text("${couponListResponse?.amount ?? ""}%",style: AppTextStyle.getOutfit600(textSize: 30, textColor: AppColors.orange),),
                                          Text("${couponListResponse?.discountType == "percent" ? double.parse(couponListResponse?.amount ?? "0.0").toInt() : couponListResponse?.amount}\t%",style: AppTextStyle.getOutfit600(textSize: 30, textColor: AppColors.orange),),
                                          const SizedBox(height: 5,),
                                          Text('DESCUENTO',style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.white),)
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(child: Text(
                                        "Descuento del 10% en Uniformes y Ropa deportiva por pertenecer a la AMPA",
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.orange),))
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Expanded(child: Row(
                                        children: [
                                          Icon(Icons.discount,color: AppColors.orange,),
                                          SizedBox(width: 5,),
                                          Text("${couponListResponse?.code}",style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.orange),)
                                        ],
                                      )),
                                      const SizedBox(width: 5,),
                                      Expanded(child: Row(
                                        children: [
                                          Icon(Icons.watch_later_outlined,color: AppColors.orange,),
                                          SizedBox(width: 5,),
                                          Text("Nunca caduca",style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.orange),)
                                        ],
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20,),

                  ],
                ),
              ),
              Consumer<StoreController>(builder: (context,storeController,child){
                return Visibility(
                    visible: storeController.isBottomSheetLoader,
                    child: LoadingLayout());
              })
            ],
          ),
        ));
  }
}
