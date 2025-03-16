import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/store_controller.dart';
import '../../../../models/store_model/product_item_model.dart';
import '../../../../utils/app_colors.dart';



class ProductListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const ProductListScreen({super.key,required this.categoryId, required this.categoryName});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  StoreController? storeController;
  StudentParentTeacherController? studentParentTeacherController;


  @override
  void initState() {
    super.initState();
    storeController = Provider.of<StoreController>(context,listen: false);
    studentParentTeacherController = Provider.of<StudentParentTeacherController>(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((res){
      storeController?.getProductList(categoryId: widget.categoryId, tiendaToken: studentParentTeacherController?.userdata?.tiendaToken ?? "");
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
          onLeadingIconClicked: (){
            Get.back();
          },
          title: Text(widget.categoryName,style: AppTextStyle.getOutfit600(textSize: 20, textColor: AppColors.white),)),
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
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar Productors',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16),

            Expanded(child: ScrollConfiguration(behavior: ScrollBehavior().copyWith(overscroll: false),

                child: Consumer<StoreController>(
              builder: (context,storeController,child){
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7, // Adjust based on your design
                  ),
                  itemCount: storeController.filterProducts.length,
                  itemBuilder: (context, index) {
                    ProductItem product = storeController.filterProducts[index];
                    return ProductCard(product: product);
                  },
                );
              },
            )))
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductItem product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Fixed height to prevent overflow
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns content vertically
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: product.images?[0].src ?? "",
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Product Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product.name ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Add to Cart or Select Options Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: product.variations?.isEmpty ?? true
                  ? ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product added to cart'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add to Cart'),
              )
                  : ElevatedButton(
                onPressed: () {
                  _showOptionsDialog(context, product.variations ?? []);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Select Option'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog for product variations
  void _showOptionsDialog(BuildContext context, List<Variations> variations) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: variations.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(variations[index].attributes?[0].name ?? ""),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${variations[index]} selected'),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
