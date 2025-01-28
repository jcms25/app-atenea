import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Scaffold(
      appBar: CustomAppBarWidget(
          title: Text(
        'Carrito',
        style:
            AppTextStyle.getOutfit500(textSize: 20, textColor: AppColors.white),
      )),
      body: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  margin: const  EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Totales del carrito',style: AppTextStyle.getOutfit800(textSize: 22, textColor: AppColors.secondary),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Text('Subtotal')),
                          Expanded(child: Text('Subtotal')),

                        ],
                      )
                    ],
                  ),
                )
                
              ],
            ),
          )),
    ));
  }
}
