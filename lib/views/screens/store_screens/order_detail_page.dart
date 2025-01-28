import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderNumber;

  const OrderDetailPage({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {},
        child: Scaffold(
          appBar: CustomAppBarWidget(
            onLeadingIconClicked: (){
              Get.back();
            },
            title: Text(
              'Detalles del pedido - $orderNumber',
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            ),
          ),
          body: ScrollConfiguration(
              behavior: ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColors.black, width: 1)),
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                        },
                        border: TableBorder(
                            verticalInside:
                                BorderSide(width: 1, color: AppColors.black)),
                        children: [
                          TableRow(children: [
                            OrderCustomTableCell(
                              value: '418',
                              label: 'Subtotal',
                            ),
                          ]),
                          TableRow(children: [
                            OrderCustomTableCell(
                              value: '418',
                              label: 'Subtotal',
                            ),
                          ]),
                          TableRow(children: [
                            OrderCustomTableCell(
                              value: '418',
                              label: 'Subtotal',
                            ),
                          ]),
                          TableRow(children: [
                            OrderCustomTableCell(
                              value: '418',
                              label: 'Subtotal',
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dirección de facturación",
                            style: AppTextStyle.getOutfit700(
                                textSize: 20, textColor: AppColors.black),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            """Antonia Alcantara Álvarez,\nC/ Manuel Bermejo Hernandez, 2, Pt. 1, 2oD 06800 Mérida,\nBadajoz,\n617831734.\n\ntonicavala@hotmail.com""",
                            style: AppTextStyle.getOutfit400(
                                textSize: 16, textColor: AppColors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}

class OrderCustomTableCell extends StatelessWidget {
  final String value;
  final String label;

  const OrderCustomTableCell(
      {super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    label,
                    style: AppTextStyle.getOutfit500(
                        textSize: 20, textColor: AppColors.black),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    value,
                    style: AppTextStyle.getOutfit400(
                        textSize: 16, textColor: AppColors.black),
                  ),
                ))
          ],
        ));
  }
}
