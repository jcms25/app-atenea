import 'package:colegia_atenea/views/screens/store_screens/checkout/total_bottom_sheet.dart';
import 'package:colegia_atenea/views/screens/store_screens/checkout/closed_items_warning_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/store_model/cart_response_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';

class CartPageScreen extends StatefulWidget {
  const CartPageScreen({super.key});

  @override
  State<CartPageScreen> createState() => _CartPageScreenState();
}

class _CartPageScreenState extends State<CartPageScreen>
    with WidgetsBindingObserver {
  StudentParentTeacherController? studentParentTeacherController;
  StoreController? storeController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    studentParentTeacherController =
        Provider.of<StudentParentTeacherController>(context, listen: false);
    storeController = Provider.of<StoreController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeController?.getCartDetails(
        tiendaToken:
            studentParentTeacherController?.userdata?.tiendaToken ?? "",
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      storeController?.getCartDetails(
        tiendaToken:
            studentParentTeacherController?.userdata?.tiendaToken ?? "",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        storeController?.setCartResponse(cartResponse: null);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            storeController?.setCartResponse(cartResponse: null);
            Get.back();
          },
          title: Text(
            'Mi Carrito',
            style:
                AppTextStyle.getOutfit600(textSize: 20, textColor: AppColors.white),
          ),
          actionIcons: [
            Consumer<StoreController>(
              builder: (context, storeController, child) {
                return Visibility(
                  visible: storeController.cartResponse?.items?.isNotEmpty ?? false,
                  child: GestureDetector(
                    onTap: () async {
                      final closedItems = storeController.cartResponse?.items
                              ?.where((item) => item.isClosed == true)
                              .toList() ??
                          [];

                      if (closedItems.isNotEmpty) {
                        Get.bottomSheet(
                          ClosedItemsWarningSheet(closedItems: closedItems),
                          isDismissible: true,
                          isScrollControlled: true,
                          backgroundColor: AppColors.transparent,
                        );
                      } else {
                        Get.bottomSheet(
                          TotalBottomSheet(),
                          isDismissible: true,
                          isScrollControlled: true,
                          backgroundColor: AppColors.transparent,
                        ).then((res) {
                          storeController.setCouponListResponse(
                            couponListResponse: null,
                          );
                        });
                      }
                    },
                    child: Text(
                      'Comprar',
                      style: AppTextStyle.getOutfit600(
                        textSize: 20,
                        textColor: AppColors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<StoreController>(
          builder: (context, storeController, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: CartListWidget(
                        cartItems: storeController.cartResponse?.items ?? [],
                      ),
                    ),
                  ],
                ),
                if (storeController.isLoading) const LoadingLayout(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CartListWidget extends StatelessWidget {
  final List<Items> cartItems;

  const CartListWidget({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return cartItems.isNotEmpty
        ? ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView.builder(
              padding: const EdgeInsets.all(2.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(cartItems[index]);
              },
            ),
          )
        : Center(
            child: Text(
              'Tu carrito está vacío',
              style: AppTextStyle.getOutfit500(
                textSize: 18,
                textColor: AppColors.secondary,
              ),
            ),
          );
  }

  Widget _buildCartItem(Items item) {
    final bool isBundledItem =
        (item.extensions?.yithWoocommerceProductBundles?.isBundledItem ?? false) ||
            (item.extensions?.wpspBundle?.wpspBundledItem ?? false);

    final int qty = (item.quantity ?? 1) <= 0 ? 1 : (item.quantity ?? 1);

    final String effectivePriceRaw =
        item.extensions?.wpspBundle?.wpspBundledItem == true
            ? (item.extensions?.wpspBundle?.wpspChildPrice ?? '0')
            : (item.prices?.price ?? '0');

    final double effectiveUnitPrice = _parseWooPriceToMajor(effectivePriceRaw);
    final double effectiveSubtotal = effectiveUnitPrice * qty;
    final double regularPrice =
        _parseWooPriceToMajor(item.prices?.regularPrice?.toString());

    return isBundledItem
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: item.images != null &&
                              item.images!.isNotEmpty &&
                              item.images![0].src != ''
                          ? Image.network(
                              item.images![0].src ?? '',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.blueAccent,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                );
                              },
                            )
                          : const Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? 'Unknown Product',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              item.type == 'yith_bundle'
                                  ? _formatPrice(regularPrice)
                                  : _formatPrice(effectiveUnitPrice),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              item.type == 'yith_bundle'
                                  ? _formatPrice(regularPrice)
                                  : _formatPrice(effectiveSubtotal),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cantidad : ${item.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: item.images != null &&
                              item.images!.isNotEmpty &&
                              item.images![0].src != ''
                          ? Image.network(
                              item.images![0].src ?? '',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.blueAccent,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                );
                              },
                            )
                          : const Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? 'Unknown Product',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              item.type == 'yith_bundle'
                                  ? _formatPrice(regularPrice)
                                  : _formatPrice(effectiveUnitPrice),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              item.type == 'yith_bundle'
                                  ? _formatPrice(regularPrice)
                                  : _formatPrice(effectiveSubtotal),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Consumer2<StoreController,
                                      StudentParentTeacherController>(
                                    builder: (
                                      context,
                                      storeController,
                                      studentParentTeacherController,
                                      child,
                                    ) {
                                      return IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          if (item.quantity == 1) {
                                            await storeController.removeCartItem(
                                              itemKey: item.key ?? '',
                                              tiendaToken:
                                                  '${studentParentTeacherController.userdata?.tiendaToken}',
                                            );
                                          } else {
                                            await storeController.updateCartItem(
                                              tiendaToken:
                                                  studentParentTeacherController
                                                          .userdata?.tiendaToken ??
                                                      '',
                                              itemKey: item.key ?? '',
                                              noOfItem: item.quantity ?? 0,
                                              increaseOrDecrease: 1,
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Consumer2<StoreController,
                                      StudentParentTeacherController>(
                                    builder: (
                                      context,
                                      storeController,
                                      studentParenTeacherController,
                                      child,
                                    ) {
                                      return IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          await storeController.updateCartItem(
                                            tiendaToken:
                                                studentParenTeacherController
                                                        .userdata?.tiendaToken ??
                                                    '',
                                            itemKey: item.key ?? '',
                                            noOfItem: item.quantity ?? 0,
                                            increaseOrDecrease: 0,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Consumer2<StoreController,
                                StudentParentTeacherController>(
                              builder: (
                                context,
                                storeController,
                                studentParentTeacherController,
                                child,
                              ) {
                                return TextButton(
                                  onPressed: () async {
                                    await storeController.removeCartItem(
                                      itemKey: item.key ?? '',
                                      tiendaToken: studentParentTeacherController
                                              .userdata?.tiendaToken ??
                                          '',
                                    );
                                  },
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  double _parseWooPriceToMajor(String? value) {
    if (value == null) return 0;
    final raw = value.trim();
    if (raw.isEmpty) return 0;

    if (raw.contains('.') || raw.contains(',')) {
      final normalized = raw.replaceAll(',', '.');
      return double.tryParse(normalized) ?? 0;
    }

    final intValue = int.tryParse(raw);
    if (intValue == null) return 0;
    return intValue / 100.0;
  }

  String _formatPrice(double amount) {
    final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '€');
    return formatter.format(amount);
  }
}