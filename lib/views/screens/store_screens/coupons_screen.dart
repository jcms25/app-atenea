import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {},
        child: Scaffold(
          appBar: CustomAppBarWidget(
              title: Text('Coupons',
                  style: AppTextStyle.getOutfit600(
                    textSize: 20,
                    textColor: AppColors.white,
                  ))),
          body: Column(
            children: [Text('')],
          ),
        ));
  }
}
