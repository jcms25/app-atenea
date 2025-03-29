// import 'package:cached_network_image/cached_network_image.dart'
//     show CachedNetworkImage;
// import 'package:colegia_atenea/controllers/store_controller.dart';
// import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
// import 'package:colegia_atenea/models/store_model/product_item_model.dart';
// import 'package:colegia_atenea/utils/app_colors.dart';
// import 'package:colegia_atenea/utils/app_textstyle.dart';
// import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
//
// class ProductDetailScreen extends StatefulWidget {
//   final String productId;
//   final String productName;
//
//   const ProductDetailScreen(
//       {super.key, required this.productId, required this.productName});
//
//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }
//
// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   StoreController? storeController;
//   StudentParentTeacherController? studentParentTeacherController;
//
//   @override
//   void initState() {
//     super.initState();
//     storeController = Provider.of<StoreController>(context, listen: false);
//     studentParentTeacherController =
//         Provider.of<StudentParentTeacherController>(context, listen: false);
//
//     WidgetsBinding.instance.addPostFrameCallback((res) {
//       storeController?.getProductDetail(
//           productId: widget.productId,
//           tiendaToken:
//               studentParentTeacherController?.userdata?.tiendaToken ?? "");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvokedWithResult: (ctx, res) {
//         storeController?.setSelectedVariations(selectedVariations: null);
//         storeController?.setProductItem(productItem: null);
//       },
//       child: Scaffold(
//         appBar: CustomAppBarWidget(
//             onLeadingIconClicked: () {
//               storeController?.setSelectedVariations(selectedVariations: null);
//               storeController?.setProductItem(productItem: null);
//               Get.back();
//             },
//             title: Text(
//               widget.productName,
//               style: AppTextStyle.getOutfit600(
//                   textSize: 20, textColor: AppColors.white),
//             )),
//         body: Consumer<StoreController>(
//           builder: (context, storeController, child) {
//             return storeController.isLoading
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl: storeController
//                                     .productItem?.images?.isNotEmpty ??
//                                 false
//                             ? storeController.productItem?.images![0].src ?? ""
//                             : "",
//                         width: double.infinity,
//                         fit: BoxFit.contain,
//                         // Ensures full image visibility
//                         placeholder: (context, url) => Container(
//                           color: Colors.grey[300],
//                           child:
//                               const Center(child: CircularProgressIndicator()),
//                         ),
//                         errorWidget: (context, url, error) => Container(
//                           color: Colors.grey[300],
//                           child: const Icon(Icons.broken_image, size: 50),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         storeController.productItem?.name ?? "",
//                         style: AppTextStyle.getOutfit600(
//                             textSize: 22, textColor: AppColors.secondary),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "${storeController.productItem?.prices?.currencySuffix} ${storeController.variationProduct == null ? storeController.productItem?.prices?.price ?? "" : storeController.variationProduct?.prices?.price ?? ""}",
//                         style: AppTextStyle.getOutfit500(
//                             textSize: 20, textColor: AppColors.secondary),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Visibility(
//                         visible: storeController
//                                 .productItem?.attributes?.isNotEmpty ??
//                             false,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               storeController
//                                       .productItem?.attributes?[0]. name ??
//                                   "",
//                               style: AppTextStyle.getOutfit500(
//                                   textSize: 20, textColor: AppColors.secondary),
//                             ),
//                             const SizedBox(height: 10),
//                             Expanded(child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: AppColors.secondary.withValues(alpha: 0.1)
//                               ),
//                               height: 60,
//                               margin: const EdgeInsets.symmetric(horizontal: 10),
//                               padding: const EdgeInsets.all(10),
//                               child: DropdownButton<Variations>(
//                                   value: storeController.selectedVariations,
//                                   isExpanded: true,
//                                   underline: const SizedBox.shrink(),
//                                   hint: Text('Elija opciones',style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary.withValues(alpha: 0.4)),),
//                                   items:
//                                   storeController.listOfVariations.map((e) {
//                                     return DropdownMenuItem<Variations>(
//                                         value: e,
//                                         child:
//                                         Text(e.attributes?[0].value ?? ""));
//                                   }).toList(),
//                                   onChanged: (Variations? variations) {
//                                     storeController.setSelectedVariations(selectedVariations: variations);
//
//                                     if(variations != null){
//                                       storeController.getProductDetail(productId: '${variations.id}', tiendaToken: studentParentTeacherController?.userdata?.tiendaToken ?? "",variationProductDetail: true);
//                                     }
//
//                                   }),
//                             ))
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';

import '../../../../models/store_model/product_item_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StoreController? storeController;
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    storeController = Provider.of<StoreController>(context, listen: false);
    studentParentTeacherController =
        Provider.of<StudentParentTeacherController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeController?.getProductDetail(
        productId: widget.productId,
        tiendaToken:
        studentParentTeacherController?.userdata?.tiendaToken ?? "",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (ctx, res) {
        storeController?.setProductItem(productItem: null);
        storeController?.setQuantity(1);
        storeController?.setSelectedVariationDetail(productItem: null);
        storeController?.setSelectedVariations(selectedVariations: null);
        storeController?.setListOfVariationAttributes(listOfVariations: []);
        // storeController?.resetProductData();
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            storeController?.setProductItem(productItem: null);
            storeController?.setQuantity(1);
            storeController?.setSelectedVariationDetail(productItem: null);
            storeController?.setSelectedVariations(selectedVariations: null);
            storeController?.setListOfVariationAttributes(listOfVariations: []);
            // storeController?.resetProductData();
            Get.back();
          },
          title: AutoSizeText(
            widget.productName,
            maxLines: 2,
            style: AppTextStyle.getOutfit600(
                textSize: 20, textColor: AppColors.white),
          ),
        ),
        body: Stack(
          children: [
            ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Consumer<StoreController>(
                    builder: (context, storeController, child) {
                      return Visibility(
                          visible: storeController.productItem != null,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: storeController.productItem?.images
                                      ?.isNotEmpty ??
                                      false
                                      ? storeController
                                      .productItem?.images![0].src ??
                                      ""
                                      : "",
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image,
                                            size: 50),
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          storeController.productItem?.name ??
                                              "",
                                          style: AppTextStyle.getOutfit600(
                                              textSize: 22,
                                              textColor: AppColors.secondary),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          storeController
                                              .selectedVariations == null
                                              ? storeController.productItem
                                              ?.prices?.priceRange == null
                                              ? AppConstants.formatPrice(double.tryParse(storeController.productItem
                                              ?.prices?.price ?? "0.0") ?? 0)
                                              : "${AppConstants.formatPrice(double.tryParse(storeController.productItem
                                              ?.prices?.priceRange
                                              ?.minAmount ?? "0.0") ?? 0)}-${AppConstants.formatPrice(double.tryParse(storeController
                                              .productItem?.prices?.priceRange
                                              ?.maxAmount ?? "0.0") ?? 0)}"
                                              : AppConstants.formatPrice(double.tryParse(storeController.variationProduct
                                              ?.prices?.price ?? "0.0") ?? 0),
                                          style: AppTextStyle.getOutfit500(
                                              textSize: 20,
                                              textColor: AppColors.secondary),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        storeController.productItem?.type == "yith_bundle" ? SizedBox.shrink() :
                                        storeController.productItem?.attributes
                                            ?.isNotEmpty ??
                                            false
                                            ? Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  storeController
                                                      .productItem
                                                      ?.attributes?[0]
                                                      .name ??
                                                      "",
                                                  style: AppTextStyle
                                                      .getOutfit500(
                                                      textSize: 20,
                                                      textColor: AppColors
                                                          .secondary),
                                                ),
                                                const SizedBox(
                                                    height: 10),
                                                Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10),
                                                          color: AppColors
                                                              .secondary
                                                              .withValues(
                                                              alpha:
                                                              0.1)),
                                                      height: 60,
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      padding:
                                                      const EdgeInsets
                                                          .all(10),
                                                      child: DropdownButton<
                                                          Variations>(
                                                          value: storeController
                                                              .selectedVariations,
                                                          isExpanded: true,
                                                          underline:
                                                          const SizedBox
                                                              .shrink(),
                                                          hint: Text(
                                                            'Elija opciones',
                                                            style: AppTextStyle
                                                                .getOutfit400(
                                                                textSize: 16,
                                                                textColor: AppColors
                                                                    .secondary
                                                                    .withValues(
                                                                    alpha:
                                                                    0.4)),
                                                          ),
                                                          items: storeController
                                                              .listOfVariations
                                                              .map((e) {
                                                            return DropdownMenuItem<
                                                                Variations>(
                                                                value: e,
                                                                child: Text(e
                                                                    .attributes?[
                                                                0]
                                                                    .value ??
                                                                    ""));
                                                          }).toList(),
                                                          onChanged:
                                                              (Variations?
                                                          variations) {
                                                            storeController
                                                                .setSelectedVariations(
                                                                selectedVariations:
                                                                variations);

                                                            if (variations !=
                                                                null) {
                                                              storeController
                                                                  .getProductDetail(
                                                                  productId:
                                                                  '${variations
                                                                      .id}',
                                                                  tiendaToken:
                                                                  studentParentTeacherController
                                                                      ?.userdata
                                                                      ?.tiendaToken ??
                                                                      "",
                                                                  variationProductDetail:
                                                                  true);
                                                            }
                                                          }),
                                                    ))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment:
                                              Alignment.centerRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  storeController
                                                      .setSelectedVariations(
                                                      selectedVariations:
                                                      null);
                                                  storeController
                                                      .setSelectedVariationDetail(
                                                      productItem:
                                                      null);
                                                },
                                                child: Text(
                                                  "claro talla",
                                                  style: AppTextStyle
                                                      .getOutfit400(
                                                      textSize: 20,
                                                      textColor:
                                                      AppColors
                                                          .primary),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                            : SizedBox.shrink(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "SKU : ${storeController
                                              .selectedVariations != null
                                              ? storeController.variationProduct
                                              ?.sku
                                              : storeController.productItem
                                              ?.sku}",
                                          style: AppTextStyle.getOutfit400(
                                              textSize: 18,
                                              textColor: AppColors.secondary),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Categorías : ${storeController
                                              .selectedVariations !=
                                              null
                                              ? storeController.variationProduct
                                              ?.categories?.map((e) {
                                            return e.name;
                                          }).join(",") ??
                                              ""
                                              : storeController
                                              .productItem?.categories?.map((
                                              e) {
                                            return e.name;
                                          }).join(",") ??
                                              ""}",
                                        )
                                      ],
                                    ))
                              ]));
                    },
                  ),
                )),
            Consumer<StoreController>(
              builder: (context, storeController, child) {
                return Visibility(
                    visible: storeController.isLoading, child: LoadingLayout());
              },
            )
          ],
        ),
        bottomNavigationBar: Consumer<StoreController>(
          builder: (context, storeController, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 10, spreadRadius: 1),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// Like Button
                  // IconButton(
                  //   icon: Icon(
                  //     storeController.isLiked ? Icons.favorite : Icons.favorite_border,
                  //     color: storeController.isLiked ? Colors.red : AppColors.secondary,
                  //   ),
                  //   onPressed: storeController.toggleLike,
                  // ),

                  /// Quantity Selector
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle,
                            color: AppColors.secondary),
                        onPressed: storeController.quantity > 1
                            ? storeController.decreaseQuantity
                            : null,
                      ),
                      Text(
                        storeController.quantity.toString(),
                        style: AppTextStyle.getOutfit600(
                            textSize: 18, textColor: AppColors.secondary),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: AppColors.primary),
                        onPressed: storeController.increaseQuantity,
                      ),
                    ],
                  ),

                  /// Add to Cart Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: storeController.isLoading
                            ? null
                            : () async{
                          await storeController.addToCart(
                              noOfItems: storeController.quantity,
                              tiendaToken: studentParentTeacherController
                                  ?.userdata?.tiendaToken ?? "",
                              productId: storeController.selectedVariations == null ? widget.productId : null,
                              variation: storeController.selectedVariations,
                             variationProductId: storeController.selectedVariations == null ? null :"${storeController.selectedVariations?.id ?? ""}", fromProductListOrFromDetails: 2
                          );
                        },
                        child: Text(
                          "Add to Cart",
                          style: AppTextStyle.getOutfit600(
                              textSize: 18, textColor: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
