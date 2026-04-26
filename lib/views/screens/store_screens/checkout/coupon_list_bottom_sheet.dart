import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/store_model/coupon_response.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CouponListBottomSheet extends StatefulWidget {
  const CouponListBottomSheet({super.key});

  @override
  State<CouponListBottomSheet> createState() => _CouponListBottomSheetState();
}

class _CouponListBottomSheetState extends State<CouponListBottomSheet> {

  StudentParentTeacherController? studentParentTeacherController;
  StoreController? storeController;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res){
      studentParentTeacherController = Provider.of<StudentParentTeacherController>(context,listen: false);
      storeController = Provider.of<StoreController>(context,listen: false);
      storeController?.getCoupons(userId: studentParentTeacherController?.userdata?.parentWpUsrId ?? "");
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.75,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Get.back();
                    }, icon: Icon(Icons.arrow_back_outlined,color: AppColors.primary,)),
                    const SizedBox(width: 10,),
                    Text('Lista de cupones',style: AppTextStyle.getOutfit400(textSize: 24, textColor: AppColors.primary),)
                  ],
                ),
               const SizedBox(height: 20,),
               Expanded(child:  Consumer<StoreController>(
                 builder: (context, storeController, child) {
                   return storeController.isBottomSheetLoader
                       ? const SizedBox()
                       : storeController.couponListResponse.isEmpty
                       ? Center(
                     child: Text(
                       'No hay ningún cupón disponible',
                       style: AppTextStyle.getOutfit400(
                           textSize: 16, textColor: AppColors.secondary),
                     ),
                   )
                      : ListView.separated(
                          itemCount:
                          storeController.couponListResponse.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            CouponListResponse couponListResponse = storeController.couponListResponse[index];
                            return CustomCouponWidget(
                           couponListResponse: couponListResponse,
                           onCouponTap: () async{
                             Get.back();
                             await storeController
                                 .applyOrRemoveCoupon(
                                 applyOrRemove: 0,
                                 couponCode:
                                 couponListResponse.code ?? "",
                                 tiendaToken:
                                 studentParentTeacherController?.userdata?.tiendaToken ??
                                     "")
                                 .then((res) {
                               storeController.setIsBottomSheetLoader(
                                   isBottomSheetLoader: false);
                             });
                           },
                         );
                       });
                 },
               ))
              ],
            ),
          ),
          Consumer<StoreController>(
            builder: (context, storeController, child) {
              return Visibility(
                  visible: storeController.isBottomSheetLoader,
                  child: LoadingLayout());
            },
          )
        ],
      ),
    );
  }
}

class CustomCouponWidget extends StatelessWidget {
  final CouponListResponse? couponListResponse;
  final VoidCallback onCouponTap;

  const CustomCouponWidget(
      {super.key, this.couponListResponse, required this.onCouponTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCouponTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.primary),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      couponListResponse?.discountType == "percent"
                          ? "${double.parse(couponListResponse?.amount ?? "0.0").toInt()}\t%"
                          : "${couponListResponse?.amount ?? ""}\t€",
                      style: AppTextStyle.getOutfit600(
                          textSize: 30, textColor: AppColors.orange),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'DESCUENTO',
                      style: AppTextStyle.getOutfit400(
                          textSize: 16, textColor: AppColors.white),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                      // "Descuento del 10% en Uniformes y Ropa deportiva por pertenecer a la AMPA",
                      couponListResponse?.description ?? "",
                      textAlign: TextAlign.start,
                      style: AppTextStyle.getOutfit400(
                          textSize: 18, textColor: AppColors.orange),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.discount,
                          color: AppColors.orange,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${couponListResponse?.code}",
                          style: AppTextStyle.getOutfit400(
                              textSize: 16, textColor: AppColors.orange),
                        )
                      ],
                    )),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: AppColors.orange,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Nunca caduca",
                          style: AppTextStyle.getOutfit400(
                              textSize: 16, textColor: AppColors.orange),
                        )
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
