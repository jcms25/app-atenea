// import 'package:colegia_atenea/controllers/store_controller.dart';
// import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
// import 'package:colegia_atenea/models/store_model/cart_response_model.dart';
// import 'package:colegia_atenea/utils/app_colors.dart';
// import 'package:colegia_atenea/utils/app_textstyle.dart';
// import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
// import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
// import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart' show Consumer, Provider;
//
// class CartPageScreen extends StatefulWidget {
//   const CartPageScreen({super.key});
//
//   @override
//   State<CartPageScreen> createState() => _CartPageScreenState();
// }
//
// class _CartPageScreenState extends State<CartPageScreen> {
//   StudentParentTeacherController? studentParentTeacherController;
//   StoreController? storeController;
//
//   @override
//   void initState() {
//     super.initState();
//     studentParentTeacherController =
//         Provider.of<StudentParentTeacherController>(context, listen: false);
//     storeController = Provider.of<StoreController>(context, listen: false);
//
//     WidgetsBinding.instance.addPostFrameCallback((res) {
//       storeController?.getCartDetails(
//           tiendaToken:
//               studentParentTeacherController?.userdata?.tiendaToken ?? "");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//         canPop: true,
//         onPopInvokedWithResult: (res, ctx) {},
//         child: Scaffold(
//           appBar: CustomAppBarWidget(
//               onLeadingIconClicked: () {
//                 Get.back();
//               },
//               title: Text(
//                 'Mi carrito',
//                 style: AppTextStyle.getOutfit600(
//                     textSize: 20, textColor: AppColors.white),
//               )),
//           body: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Consumer<StoreController>(
//                       builder: (context, storeController, child) {
//                     return Container(
//                       width: MediaQuery.sizeOf(context).width,
//                       color: AppColors.blue.withValues(alpha: 0.4),
//                       padding: const EdgeInsets.all(10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Totales del carrito',
//                             style: AppTextStyle.getOutfit600(
//                                 textSize: 24, textColor: AppColors.secondary),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Subtotal',
//                                 style: AppTextStyle.getOutfit500(
//                                     textSize: 20,
//                                     textColor: AppColors.secondary),
//                               ),
//                               Spacer(),
//                               Expanded(
//                                   child: Text(
//                                 '${storeController.cartResponse?.totals?.totalPrice ?? 0}\t€',
//                                 textAlign: TextAlign.right,
//                                 style: AppTextStyle.getOutfit500(
//                                     textSize: 18,
//                                     textColor: AppColors.secondary),
//                               ))
//                             ],
//                           ),
//                           Divider(
//                             height: 15,
//                             color: AppColors.secondary,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Total',
//                                 style: AppTextStyle.getOutfit500(
//                                     textSize: 20,
//                                     textColor: AppColors.secondary),
//                               ),
//                               Spacer(),
//                               Expanded(
//                                   child: Text(
//                                 '${storeController.cartResponse?.totals?.totalPrice ?? 0}\t€ (incluye ${storeController.cartResponse?.totals?.taxLines?.map((e){return "${e.price ?? 0.0}€ (${e.name})";}).join(",")})',
//                                 textAlign: TextAlign.right,
//                                 style: AppTextStyle.getOutfit500(
//                                     textSize: 18,
//                                     textColor: AppColors.secondary),
//                               ))
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           CustomButtonWidget(
//                             buttonTitle: 'Finalizar compra'.toUpperCase(),
//                             onPressed: () {
//
//                             },
//                             backgroundColor: AppColors.orange,
//                             textColor: AppColors.secondary,
//                           )
//                         ],
//                       ),
//                     );
//                   }),
//                   Expanded(child: CartListWidget(cartItems: storeController?.cartResponse?.items ?? []))
//                 ],
//               ),
//               Consumer<StoreController>(
//                   builder: (context, storeController, child) {
//                 return Visibility(
//                     visible: storeController.isLoading, child: LoadingLayout());
//               })
//             ],
//           ),
//         ));
//   }
// }
//
//
//
//
// class CartListWidget extends StatelessWidget {
//   final List<Items> cartItems;
//   const CartListWidget({super.key, required this.cartItems});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: cartItems.length,
//       itemBuilder: (context, index) {
//         return Card(
//           margin: EdgeInsets.all(8.0),
//           child: ListTile(
//             // leading: Image.network(cartItems[index]['image'], width: 60, height: 60),
//             title: Text(cartItems[index].name ?? "",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             subtitle: Text('${cartItems[index].prices?.price}€'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.remove),
//                   // onPressed: () => updateQuantity(index, -1),
//                   onPressed: (){},
//                 ),
//                 Text('${cartItems[index].quantity}'),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   // onPressed: () => updateQuantity(index, 1),
//                   onPressed: (){},
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:colegia_atenea/views/screens/store_screens/checkout/total_bottom_sheet.dart';
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

class _CartPageScreenState extends State<CartPageScreen> with WidgetsBindingObserver {
  StudentParentTeacherController? studentParentTeacherController;
  StoreController? storeController;

  @override
  void initState() {
    super.initState();
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      storeController?.getCartDetails(tiendaToken: studentParentTeacherController?.userdata?.tiendaToken ?? "");
    }

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
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
              style: AppTextStyle.getOutfit600(
                  textSize: 20, textColor: AppColors.white),
            ),
            actionIcons: [
              Consumer<StoreController>(
                builder: (context, storeController, child) {
                  return Visibility(
                      visible:
                          storeController.cartResponse?.items?.isNotEmpty ??
                              false,
                      child: GestureDetector(
                        onTap: (){
                           Get.bottomSheet(TotalBottomSheet(),
                              isDismissible: true,
                              isScrollControlled: true,
                              backgroundColor: AppColors.transparent).then((res){
                                storeController.setCouponListResponse(couponListResponse: null);
                          });
                        },
                        child: Text(
                          'Comprar',
                          style: AppTextStyle.getOutfit600(
                              textSize: 20, textColor: AppColors.white),
                        ),
                      ));
                },
              )
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
                              cartItems:
                                  storeController.cartResponse?.items ?? [])),
                    ],
                  ),
                  if (storeController.isLoading) const LoadingLayout(),
                ],
              );
            },
          ),
        ));
  }
}

class CartListWidget extends StatelessWidget {
  final List<Items> cartItems;

  const CartListWidget({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return cartItems.isNotEmpty
        ? ScrollConfiguration(behavior: const ScrollBehavior().copyWith(overscroll: false), child: ListView.builder(
      padding: const EdgeInsets.all(2.0),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return _buildCartItem(cartItems[index]);
      },
    ))
        : Center(
            child: Text(
              'Tu carrito está vacío',
              style: AppTextStyle.getOutfit500(
                  textSize: 18, textColor: AppColors.secondary),
            ),
          );
  }

  Widget _buildCartItem(Items item) {
    double price = double.tryParse(item.prices?.price ?? "0") ?? 0;
    double subtotal = price * (item.quantity ?? 1);

    return item.extensions?.yithWoocommerceProductBundles?.isBundledItem ??
            false
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        // Soft border
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: item.images != null &&
                              item.images!.isNotEmpty &&
                              item.images![0].src != ""
                          ? Image.network(
                              item.images![0].src ?? "",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.blueAccent),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image,
                                    size: 40, color: Colors.grey);
                              },
                            )
                          : const Icon(Icons.image,
                              size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12), // Space between image and details

                  // Product Details & Quantity Controls
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name (Full name without ellipsis)
                        Text(
                          item.name ?? "Unknown Product",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),

                        // Price & Subtotal Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Price:',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade700)),
                            Text(
                                item.type == "yith_bundle"
                                    ? _formatPrice(double.tryParse(
                                            item.prices?.regularPrice ??
                                                "0.0") ??
                                        0)
                                    : _formatPrice(price),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal:',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade700)),
                            Text(
                                item.type == "yith_bundle"
                                    ? _formatPrice(double.tryParse(
                                            item.prices?.regularPrice ??
                                                "0.0") ??
                                        0)
                                    : _formatPrice(subtotal),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Quantity & Remove Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity Controls
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey[200],
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            //   child: Row(
                            //     children: [
                            //       IconButton(
                            //         icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                            //         onPressed: () {
                            //           // Decrease quantity logic
                            //         },
                            //       ),
                            Text('Cantidad : ${item.quantity}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            //       IconButton(
                            //         icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 20),
                            //         onPressed: () {
                            //           // Increase quantity logic
                            //
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            //
                            // // Remove Button
                            // Consumer2<StoreController,StudentParentTeacherController>(
                            //   builder: (context,storeController,studentParentTeacherController,child){
                            //     return  TextButton(
                            //       onPressed: () async{
                            //         // Remove item from cart logic
                            //         await storeController.removeCartItem(itemKey: item.key ?? "", tiendaToken: studentParentTeacherController.userdata?.tiendaToken ?? "");
                            //       },
                            //       child: const Text("Remove", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            //     );
                            //   },
                            // ),
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
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        // Soft border
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: item.images != null &&
                              item.images!.isNotEmpty &&
                              item.images![0].src != ""
                          ? Image.network(
                              item.images![0].src ?? "",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.blueAccent),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image,
                                    size: 40, color: Colors.grey);
                              },
                            )
                          : const Icon(Icons.image,
                              size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12), // Space between image and details

                  // Product Details & Quantity Controls
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name (Full name without ellipsis)
                        Text(
                          item.name ?? "Unknown Product",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),

                        // Price & Subtotal Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Price:',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade700)),
                            Text(
                                item.type == "yith_bundle"
                                    ? _formatPrice(double.tryParse(
                                            item.prices?.regularPrice ??
                                                "0.0") ??
                                        0)
                                    : _formatPrice(price),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal:',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade700)),
                            Text(
                                item.type == "yith_bundle"
                                    ? _formatPrice(double.tryParse(
                                            item.prices?.regularPrice ??
                                                "0.0") ??
                                        0)
                                    : _formatPrice(subtotal),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Quantity & Remove Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity Controls
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Row(
                                children: [
                                  Consumer2<StoreController,
                                      StudentParentTeacherController>(
                                    builder: (context, storeController,
                                        studentParentTeacherController, child) {
                                      return IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                            size: 20),
                                        onPressed: () async {
                                          // Decrease quantity logic
                                          if (item.quantity == 1) {
                                            await storeController.removeCartItem(
                                                itemKey: item.key ?? "",
                                                tiendaToken:
                                                    "${studentParentTeacherController.userdata?.tiendaToken}");
                                          } else {
                                            await storeController.updateCartItem(
                                                tiendaToken:
                                                    studentParentTeacherController
                                                            .userdata
                                                            ?.tiendaToken ??
                                                        "",
                                                itemKey: item.key ?? "",
                                                noOfItem: item.quantity ?? 0,
                                                increaseOrDecrease: 1);


                                          }
                                        },
                                      );
                                    },
                                  ),
                                  Text('${item.quantity}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Consumer2<StoreController,
                                      StudentParentTeacherController>(
                                    builder: (context, storeController,
                                        studentParenTeacherController, child) {
                                      return IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.green,
                                            size: 20),
                                        onPressed: () async {
                                          // Increase quantity logic
                                          await storeController.updateCartItem(
                                              tiendaToken:
                                                  studentParenTeacherController
                                                          .userdata
                                                          ?.tiendaToken ??
                                                      "",
                                              itemKey: item.key ?? "",
                                              noOfItem: item.quantity ?? 0,
                                              increaseOrDecrease: 0);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Remove Button
                            Consumer2<StoreController,
                                StudentParentTeacherController>(
                              builder: (context, storeController,
                                  studentParentTeacherController, child) {
                                return TextButton(
                                  onPressed: () async {
                                    // Remove item from cart logic
                                    await storeController.removeCartItem(
                                        itemKey: item.key ?? "",
                                        tiendaToken:
                                            studentParentTeacherController
                                                    .userdata?.tiendaToken ??
                                                "");
                                  },
                                  child: const Text("Remove",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
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

// Helper function to format price
  String _formatPrice(double price) {
    double priceFormat = price / 100; // Convert cents to euros
    final formatter = NumberFormat.currency(locale: 'de_DE', symbol: '€');
    return formatter.format(priceFormat); // Example: 2514 -> "25,14 €"
  }
}
