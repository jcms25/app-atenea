import 'package:colegia_atenea/models/store_model/product_item_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BundlesProductListBottomSheet extends StatelessWidget {
  final List<BundleData> listOfBundleProducts;
  const BundlesProductListBottomSheet({super.key, required this.listOfBundleProducts});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25)
        )
      ),
      padding: const  EdgeInsets.all(10).copyWith(top: 30),
      child: listOfBundleProducts.isEmpty ? Center(
        child: Text('No hay productos.',style: AppTextStyle.getOutfit500(textSize: 20, textColor: AppColors.secondary),),
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Productos",style: AppTextStyle.getOutfit500(textSize: 18, textColor: AppColors.secondary),),
              IconButton(onPressed: (){
                Get.back();
              }, icon: Icon(Icons.cancel,color: AppColors.primary,size: 25,))
            ],
          ),
          const SizedBox(height: 10,),
          Expanded(child: ScrollConfiguration(behavior: const ScrollBehavior().copyWith(overscroll: false), child: ListView.builder(
              itemCount: listOfBundleProducts.length,
              itemBuilder: (context,index){
                BundleData bundleData = listOfBundleProducts[index];
                return Container(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2),width: 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            child: bundleData.bpProductImg != null &&
                                bundleData.bpProductImg!.isNotEmpty &&
                                bundleData.bpProductImg != ""
                                ? Image.network(
                              bundleData.bpProductImg ?? "",
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
                        SizedBox(width: 10,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(bundleData.bpProductName ?? "-",style: AppTextStyle.getOutfit400(textSize: 14, textColor: AppColors.secondary),),
                            SizedBox(height: 5,),
                            Text("${bundleData.bpProductPrice?.replaceAll(".", ",") ?? "-"}\t€",style: AppTextStyle.getOutfit400(textSize: 14, textColor: AppColors.primary),)
                          ],
                        ))
                      ],
                    ),
                  ),
                );
              })))
        ],
      )
   
    );
  }
}
