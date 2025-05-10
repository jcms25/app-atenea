import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/store_model/coupon_response.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/store_screens/checkout/coupon_list_bottom_sheet.dart';
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
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res){
        storeController = Provider.of<StoreController>(context,listen: false);
        studentParentTeacherController = Provider.of<StudentParentTeacherController>(context,listen: false);
        storeController?.getCoupons(userId: studentParentTeacherController?.userdata?.parentWpUsrId ?? "");
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



                    Expanded(child: Consumer<StoreController>(
                      builder: (context,storeController,child){
                        return ListView.separated(

                            itemCount: storeController.couponListResponse.length,
                            separatorBuilder: (context,index){
                              return SizedBox(height: 10,);
                            },
                            itemBuilder: (context,index){
                              CouponListResponse couponListResponse = storeController.couponListResponse[index];
                              return CustomCouponWidget(couponListResponse: storeController.couponListResponse[index], onCouponTap: (){
                                onCouponItemClick(couponListResponse);
                              },);
                            });
                      },
                    )),



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


  void onCouponItemClick(CouponListResponse couponListResponse) async{
    Get.dialog(
        barrierDismissible: true,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Aplicar cupón',style: AppTextStyle.getOutfit600(textSize: 22, textColor: AppColors.secondary),),
          content: Text('¿Quieres aplicar un cupón con el código de cupón: ${couponListResponse.code} ?'),
          actions: [
            CustomButtonWidget(buttonTitle: 'No', onPressed: (){
              Get.back();
            } ),
            const SizedBox(height: 10,),
            Consumer2<StoreController,StudentParentTeacherController>(
              builder: (context,storeController,studentParentTeacherController,child){
                return CustomButtonWidget(buttonTitle: 'Sí', onPressed: () async{

                  Get.back();
                  await storeController.applyOrRemoveCoupon(applyOrRemove: 0, couponCode: couponListResponse.code ?? "", tiendaToken: studentParentTeacherController.userdata?.tiendaToken ?? "").then((res){
                    storeController.setIsBottomSheetLoader(isBottomSheetLoader: false);
                  });
                } );
              },
            )
          ],
        ));
  }
}
