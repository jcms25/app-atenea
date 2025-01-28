import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/screens/store_screens/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  StoreController? storeController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      storeController = Provider.of<StoreController>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (es, ctx) {},
        child: Scaffold(
          appBar: CustomAppBarWidget(
              onLeadingIconClicked: () {
                Get.back();
              },
              title: Text(
                'Mis Compras Atenea',
                style: AppTextStyle.getOutfit500(
                    textSize: 20, textColor: AppColors.white),
              )),
          body: Consumer<StoreController>(
            builder: (context, storeController, child) {
              return storeController.listOfOrders.isEmpty
                  ? Center(
                      child: Text(
                        'Sin historial de pedidos.',
                        style: AppTextStyle.getOutfit500(
                            textSize: 18, textColor: AppColors.secondary),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Histórico de pedidos',
                            style: AppTextStyle.getOutfit700(
                                textSize: 20, textColor: AppColors.secondary),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              child: ScrollConfiguration(
                                  behavior: ScrollBehavior()
                                      .copyWith(overscroll: false),
                                  child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        return OrderHistoryWidget(
                                            orderHistory: storeController
                                                .listOfOrders[index]);
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 20,
                                        );
                                      },
                                      itemCount:
                                          storeController.listOfOrders.length)))
                        ],
                      ),
                    );
            },
          ),
        ));
  }
}

class OrderHistory {
  String? orderNumber;
  String? orderDate;
  String? orderStatus;
  String? orderTotal;

  OrderHistory(
      {this.orderNumber, this.orderDate, this.orderStatus, this.orderTotal});
}

class OrderHistoryWidget extends StatelessWidget {
  final OrderHistory orderHistory;

  const OrderHistoryWidget({super.key, required this.orderHistory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                orderHistory.orderNumber ?? "",
                style: AppTextStyle.getOutfit400(
                    textSize: 18, textColor: AppColors.white),
              )),
              Text(
                orderHistory.orderDate ?? "",
                style: AppTextStyle.getOutfit400(
                    textSize: 18, textColor: AppColors.white),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.black, width: 1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              OrderRowWidget(
                  label: 'Estado', value: orderHistory.orderStatus ?? ""),
              SizedBox(
                height: 10,
              ),
              OrderRowWidget(label: 'Total', value: "7,35 €para 7 articulos"),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: CustomButtonWidget(
                          buttonTitle: 'Invoice', onPressed: () {})),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: CustomButtonWidget(
                          buttonTitle: 'View', onPressed: () {
                            Get.to(() => OrderDetailPage(orderNumber: orderHistory.orderNumber ?? "",));
                      })),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class OrderRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const OrderRowWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          label,
          style: AppTextStyle.getOutfit500(
              textSize: label == "Total" ? 22 : 18,
              textColor: AppColors.secondary),
        )),
        Expanded(
            child: Text(
          value,
          style: AppTextStyle.getOutfit400(
              textSize: 16, textColor: AppColors.secondary),
          textAlign: TextAlign.right,
        ))
      ],
    );
  }
}
