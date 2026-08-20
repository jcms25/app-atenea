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
  final Set<int> _expandedCoupons = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res) {
      storeController = Provider.of<StoreController>(context, listen: false);
      studentParentTeacherController = Provider.of<StudentParentTeacherController>(context, listen: false);
      storeController?.getCoupons(userId: studentParentTeacherController?.userdata?.parentWpUsrId ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<StudentParentTeacherController>(context, listen: false);
    final isAmpa = ctrl.userdata?.userRoles?.contains('ampa') == true;

    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          storeController?.setCouponListResponse(couponListResponse: null);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
              onLeadingIconClicked: () {
                storeController?.setCouponListResponse(couponListResponse: null);
                Get.back();
              },
              title: Text('Cupones',
                  style: AppTextStyle.getOutfit600(
                    textSize: 20,
                    textColor: AppColors.white,
                  ))),
          body: Consumer<StoreController>(
            builder: (context, storeController, child) {
              final ampaCoupons = isAmpa
                  ? storeController.couponListResponse.where((c) => c.isAmpaFamiliar == true).toList()
                  : <CouponListResponse>[];

              return Stack(
                children: [
                  SingleChildScrollView(
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
                        const SizedBox(height: 20),

                        Text('Cupones disponibles',
                            style: AppTextStyle.getOutfit500(textSize: 18, textColor: AppColors.secondary)),
                        const SizedBox(height: 12),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: storeController.couponListResponse.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            CouponListResponse couponListResponse = storeController.couponListResponse[index];
                            return CustomCouponWidget(
                              couponListResponse: storeController.couponListResponse[index],
                              onCouponTap: () => onCouponItemClick(couponListResponse),
                            );
                          },
                        ),

                        if (isAmpa && ampaCoupons.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text('Uso de cupones AMPA',
                              style: AppTextStyle.getOutfit500(textSize: 18, textColor: AppColors.secondary)),
                          const SizedBox(height: 4),
                          Text(
                            'Consulta los descuentos aplicados y el saldo disponible de cada cupón.',
                            style: AppTextStyle.getOutfit400(textSize: 13, textColor: AppColors.secondary),
                          ),
                          const SizedBox(height: 12),
                          ...ampaCoupons.map((cupon) {
                            final disponible = cupon.ampaAvailable ?? 0;
                            final usado = cupon.ampaUsed ?? 0;
                            final limite = cupon.ampaLimit ?? 0;
                            final String estado;
                            final Color estadoColor;
                            if (disponible <= 0) {
                              estado = 'AGOTADO';
                              estadoColor = Colors.red;
                            } else if (usado > 0) {
                              estado = 'PARCIAL';
                              estadoColor = Colors.orange;
                            } else {
                              estado = 'DISPONIBLE';
                              estadoColor = Colors.green;
                            }
                            final isExpanded = _expandedCoupons.contains(cupon.id);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      setState(() {
                                        if (isExpanded) {
                                          _expandedCoupons.remove(cupon.id);
                                        } else {
                                          _expandedCoupons.add(cupon.id ?? 0);
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      (cupon.code ?? '').toUpperCase(),
                                                      style: AppTextStyle.getOutfit600(
                                                          textSize: 13, textColor: AppColors.secondary),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: estadoColor.withValues(alpha: 0.1),
                                                        borderRadius: BorderRadius.circular(20),
                                                        border: Border.all(color: estadoColor),
                                                      ),
                                                      child: Text(estado,
                                                          style: AppTextStyle.getOutfit600(
                                                              textSize: 10, textColor: estadoColor)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Límite: ${limite.toStringAsFixed(2)} €   Usado: ${usado.toStringAsFixed(2)} €   Disponible: ${disponible.toStringAsFixed(2)} €',
                                                  style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            isExpanded ? Icons.expand_less : Icons.expand_more,
                                            color: AppColors.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isExpanded)
                                    _buildDetalleCupon(cupon),
                                ],
                              ),
                            );
                          }),
                        ],

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: storeController.isBottomSheetLoader,
                      child: LoadingLayout()),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildDetalleCupon(CouponListResponse cupon) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text('Detalle de uso', style: AppTextStyle.getOutfit600(textSize: 13, textColor: AppColors.secondary)),
          const SizedBox(height: 8),
          Text(
            'Descarga el informe en PDF con el detalle de pedidos y artículos de este cupón.',
            style: AppTextStyle.getOutfit400(textSize: 12, textColor: AppColors.secondary),
          ),
          const SizedBox(height: 12),
          CustomButtonWidget(
            buttonTitle: 'Descargar informe (PDF)',
            onPressed: () async {
              await storeController?.descargarInformeAmpaPdf(
                userId: studentParentTeacherController?.userdata?.parentWpUsrId ?? "",
                couponCode: cupon.code ?? "",
              );
            },
          ),
        ],
      ),
    );
  }

  void onCouponItemClick(CouponListResponse couponListResponse) async {
    Get.dialog(
        barrierDismissible: true,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Aplicar cupón',
              style: AppTextStyle.getOutfit600(textSize: 22, textColor: AppColors.secondary)),
          content: Text('¿Quieres aplicar un cupón con el código de cupón: ${couponListResponse.code} ?'),
          actions: [
            CustomButtonWidget(buttonTitle: 'No', onPressed: () => Get.back()),
            const SizedBox(height: 10),
            Consumer2<StoreController, StudentParentTeacherController>(
              builder: (context, storeController, studentParentTeacherController, child) {
                return CustomButtonWidget(
                    buttonTitle: 'Sí',
                    onPressed: () async {
                      Get.back();
                      await storeController.applyOrRemoveCoupon(
                          applyOrRemove: 0,
                          couponCode: couponListResponse.code ?? "",
                          tiendaToken: studentParentTeacherController.userdata?.tiendaToken ?? "")
                          .then((res) {
                        storeController.setIsBottomSheetLoader(isBottomSheetLoader: false);
                      });
                    });
              },
            )
          ],
        ));
  }
}