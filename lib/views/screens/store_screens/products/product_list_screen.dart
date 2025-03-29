// import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
// import 'package:colegia_atenea/utils/app_constants.dart';
// import 'package:colegia_atenea/utils/app_textstyle.dart';
// import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
// import 'package:colegia_atenea/views/screens/store_screens/products/product_detail_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../controllers/store_controller.dart';
// import '../../../../models/store_model/product_item_model.dart';
// import '../../../../utils/app_colors.dart';
//
// class ProductListScreen extends StatefulWidget {
//   final String categoryId;
//   final String categoryName;
//
//   const ProductListScreen(
//       {super.key, required this.categoryId, required this.categoryName});
//
//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }
//
// class _ProductListScreenState extends State<ProductListScreen> {
//
//   StoreController? storeController;
//   StudentParentTeacherController? studentParentTeacherController;
//
//
//   @override
//   void initState() {
//     super.initState();
//     storeController = Provider.of<StoreController>(context,listen: false);
//     studentParentTeacherController = Provider.of<StudentParentTeacherController>(context,listen: false);
//     WidgetsBinding.instance.addPostFrameCallback((res){
//       storeController?.getProductList(categoryId: widget.categoryId, tiendaToken: studentParentTeacherController?.userdata?.tiendaToken ?? "");
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//         onPopInvokedWithResult: (res,ctx){
//           storeController?.setProductList(listOfProducts: []);
//         },
//         child: Scaffold(
//       appBar: CustomAppBarWidget(
//           onLeadingIconClicked: (){
//             storeController?.setProductList(listOfProducts: []);
//             Get.back();
//           },
//           title: Text(widget.categoryName,style: AppTextStyle.getOutfit600(textSize: 20, textColor: AppColors.white),)),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Buscar Productors',
//                   border: InputBorder.none,
//                   icon: Icon(Icons.search, color: Colors.grey),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             Expanded(child: ScrollConfiguration(behavior: ScrollBehavior().copyWith(overscroll: false),
//
//                 child: Consumer<StoreController>(
//                   builder: (context,storeController,child){
//                     return storeController.isLoading
//                         ? Center(child: CircularProgressIndicator())
//                         : GridView.builder(
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 8,
//                         mainAxisSpacing: 8,
//                         childAspectRatio: 0.7, // Adjust based on your design
//                       ),
//                       itemCount: storeController.filterProducts.length,
//                       itemBuilder: (context, index) {
//                         ProductItem product = storeController.filterProducts[index];
//                         return ProductCard(product: product);
//                       },
//                     );
//                   },
//                 )))
//           ],
//         ),
//       ),
//     ));
//   }
// }
//
//
//
// class ProductCard extends StatelessWidget {
//   final ProductItem product;
//
//   const ProductCard({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 4,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ✅ Image Section (Flexible to avoid overflow)
//           Expanded(
//             flex: 6,
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//               child: CachedNetworkImage(
//                 imageUrl: product.images?.isNotEmpty ?? false
//                     ? product.images![0].src ?? ""
//                     : "",
//                 width: double.infinity,
//                 fit: BoxFit.contain,
//                 // Ensures full image visibility
//                 placeholder: (context, url) => Container(
//                   color: Colors.grey[300],
//                   child: const Center(child: CircularProgressIndicator()),
//                 ),
//                 errorWidget: (context, url, error) => Container(
//                   color: Colors.grey[300],
//                   child: const Icon(Icons.broken_image, size: 50),
//                 ),
//               ),
//             ),
//           ),
//
//           // ✅ Product Info (Name & Price)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Name
//                 Text(
//                   product.name ?? 'Product Name',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//
//                 const SizedBox(height: 5),
//
//                 Text(
//                   // "${product.prices?.currencySymbol ?? ''}${_formatPrice(product.prices?.price ?? '0', product.prices)}",
//                   // style: const TextStyle(
//                   //   fontSize: 16,
//                   //   fontWeight: FontWeight.bold,
//                   //   color: Colors.green,
//                   // ),
//                   AppConstants.formatPrice(double.tryParse(product.prices?.price ?? "0") ?? 0),
//                   style: AppTextStyle.getOutfit400(
//                       textSize: 16, textColor: AppColors.primary),
//                 ),
//               ],
//             ),
//           ),
//
//           const Spacer(), // Pushes button to bottom
//
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: SizedBox(
//               width: double.infinity,
//               child: Consumer2<StoreController,StudentParentTeacherController>(
//                 builder: (context,storeController,studentParentTeacherController,child){
//                   return ElevatedButton(
//                     onPressed: () async{
//                       // if (product.variations?.isEmpty ?? true) {
//                       //   ScaffoldMessenger.of(context).showSnackBar(
//                       //     const SnackBar(content: Text('Product added to cart')),
//                       //   );
//                       // } else {
//                       //   _showOptionsDialog(context, product.variations ?? []);
//                       // }
//                       if(product.variations?.isNotEmpty ?? false){
//                         Get.to(() => ProductDetailScreen(productId: "${product.id}", productName: product.name ?? ""));
//                       }else{
//                         await storeController.addToCart(noOfItems: storeController.quantity, tiendaToken: studentParentTeacherController.userdata?.tiendaToken ?? "");
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Icon(Icons.shopping_cart, color: AppColors.white),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                             child: Text(product.variations?.isEmpty ?? true
//                                 ? 'Añadir al carrito'
//                                 : 'Seleccionar opciones')
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
// }



import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/store_screens/products/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controllers/store_controller.dart';
import '../../../../models/store_model/product_item_model.dart';
import '../../../../utils/app_colors.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  StoreController? storeController;
  StudentParentTeacherController? studentParentTeacherController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    storeController = Provider.of<StoreController>(context, listen: false);
    studentParentTeacherController = Provider.of<StudentParentTeacherController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeController?.getProductList(categoryId: widget.categoryId, tiendaToken: studentParentTeacherController?.userdata?.tiendaToken ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        onLeadingIconClicked: () {
          storeController?.setProductList(listOfProducts: []);
          Get.back();
        },
        title: Text(widget.categoryName, style: AppTextStyle.getOutfit600(textSize: 20, textColor: AppColors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: TextField(
                onChanged: (query) => storeController?.searchInProductList(query),
                decoration: InputDecoration(
                  hintText: 'Buscar Productos',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  Consumer<StoreController>(
                    builder: (context, storeController, child) {
                      return GridView.builder(
                        controller: _scrollController,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: storeController.filterProducts.length,
                        itemBuilder: (context, index) {
                          ProductItem product = storeController.filterProducts[index];
                          return ProductCard(product: product);
                        },
                      );
                    },
                  ),
                  Consumer<StoreController>(
                    builder: (context,storeController,child){
                      return Visibility(
                          visible: storeController.isLoading,
                          child: LoadingLayout(
                            backgroundColor: AppColors.transparent,
                          ));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductItem product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Image Section (Flexible to avoid overflow)
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: product.images?.isNotEmpty ?? false
                    ? product.images![0].src ?? ""
                    : "",
                width: double.infinity,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
          ),

          // ✅ Product Info (Name & Price)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Product Name
                Text(
                  product.name ?? 'Product Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 5),

                // ✅ Product Price
                Text(
                  // product.prices?.price == null || product.prices?.price == "0" ?
                  //     "${AppConstants.formatPrice(double.tryParse(product.prices?.priceRange?.minAmount ?? "0.0") ?? 0.0)} - ${AppConstants.formatPrice(double.tryParse(product.prices?.priceRange?.maxAmount ?? "0.0") ?? 0.0)}"
                  //     :
                  // AppConstants.formatPrice(
                  //   double.tryParse(product.prices?.price ?? "0") ?? 0,
                  // ),
                  product.variations?.isNotEmpty ?? false ? product.prices?.priceRange != null ? "${AppConstants.formatPrice(double.tryParse(product.prices?.priceRange?.minAmount ?? "0.0") ?? 0.0)} - ${AppConstants.formatPrice(double.tryParse(product.prices?.priceRange?.maxAmount ?? "0.0") ?? 0.0)}" : AppConstants.formatPrice(
                    double.tryParse(product.prices?.price ?? "0") ?? 0,
                  ) : "",
                  style: AppTextStyle.getOutfit400(
                    textSize: 16,
                    textColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(), // Pushes button to bottom

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: double.infinity,
              child: Consumer2<StoreController, StudentParentTeacherController>(
                builder: (context, storeController, studentParentTeacherController, child) {
                  bool isLoading = storeController.isProductLoading("${product.id ?? 0}");

                  return ElevatedButton(
                    onPressed: storeController.isProductLoading("${product.id ?? 0}")
                        ? null
                        : () async {
                      if (product.variations?.isNotEmpty ?? false) {
                        Get.to(() => ProductDetailScreen(
                          productId: "${product.id}",
                          productName: product.name ?? "",
                        ));
                      } else {
                        await storeController.addToCart(
                          noOfItems: storeController.quantity,
                          tiendaToken: studentParentTeacherController.userdata?.tiendaToken ?? "",
                          productId: "${product.id ?? 0}", fromProductListOrFromDetails: 1
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: AppColors.white) // ✅ Show loader while adding to cart
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.shopping_cart, color: AppColors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            product.variations?.isEmpty ?? true
                                ? 'Añadir al carrito'
                                : 'Seleccionar opciones',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

