import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res,ctx){},
        child: Scaffold(
          appBar: CustomAppBarWidget(
              onLeadingIconClicked: (){
                Get.back();
              },
              title: Text('subMenuDrawer18'.tr,style: AppTextStyle.getOutfit500(textSize: 20, textColor: AppColors.white),)),
        ));
  }
}
