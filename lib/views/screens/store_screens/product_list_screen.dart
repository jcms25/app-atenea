import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class ProductListScreen extends StatelessWidget {
  final String productCategory;

  const ProductListScreen({super.key, required this.productCategory});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (ctx, res) {},
      child: Scaffold(
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            Get.back();
          },
          title: Text(
            productCategory,
            style: AppTextStyle.getOutfit500(
                textSize: 20, textColor: AppColors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: AppConstants.subMenuListStore.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.black, width: 1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: SvgPicture.asset(AppConstants.subMenuListStore[index]['icon'] ?? "")),
                      Text("${AppConstants.subMenuListStore[index]['name']}")
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
