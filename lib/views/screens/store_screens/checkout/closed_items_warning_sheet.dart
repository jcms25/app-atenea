import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/store_model/cart_response_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/screens/store_screens/checkout/total_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ClosedItemsWarningSheet extends StatelessWidget {
  final List<Items> closedItems;

  const ClosedItemsWarningSheet({super.key, required this.closedItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Productos no disponibles',
                  style: AppTextStyle.getOutfit600(
                      textSize: 20, textColor: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Los siguientes productos pertenecen a una categoría cerrada. Elimínalos del carrito para continuar con la compra.',
            style: AppTextStyle.getOutfit400(
                textSize: 15, textColor: AppColors.secondary),
          ),
          const SizedBox(height: 20),
          ...closedItems.map((item) => Consumer2<StoreController, StudentParentTeacherController>(
            builder: (context, storeController, studentParentTeacherController, child) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.secondary.withValues(alpha: 0.06),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name ?? '',
                        style: AppTextStyle.getOutfit500(
                            textSize: 16, textColor: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        await storeController.removeCartItem(
                          itemKey: item.key ?? '',
                          tiendaToken: studentParentTeacherController.userdata?.tiendaToken ?? '',
                        );
                        // Si ya no quedan ítems cerrados, abrimos TotalBottomSheet
                        final remaining = storeController.cartResponse?.items
                            ?.where((i) => i.isClosed == true)
                            .toList() ?? [];
                        if (remaining.isEmpty) {
                          Get.back();
                          Get.bottomSheet(
                            TotalBottomSheet(),
                            isDismissible: true,
                            isScrollControlled: true,
                            backgroundColor: AppColors.transparent,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Eliminar',
                          style: AppTextStyle.getOutfit500(
                              textSize: 14, textColor: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}