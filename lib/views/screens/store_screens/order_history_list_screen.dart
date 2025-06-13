import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/store_model/order_list_model.dart';
import '../../../utils/app_colors.dart';
import 'order_detail_page.dart';


class OrderHistoryListScreen extends StatefulWidget {
  const OrderHistoryListScreen({super.key});

  @override
  State<OrderHistoryListScreen> createState() => _OrderHistoryListScreenState();
}

class _OrderHistoryListScreenState extends State<OrderHistoryListScreen> {
  StoreController? storeController;
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      storeController = Provider.of<StoreController>(context, listen: false);
      studentParentTeacherController = Provider.of<StudentParentTeacherController>(context,listen: false);
      storeController?.getListOfOrders(wpUserId: studentParentTeacherController?.userdata?.parentWpUsrId ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (es, ctx) {
          storeController?.setIsLoading(isLoading: false);
          storeController?.setListOfOrders(listOfOrders: []);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
              onLeadingIconClicked: () {
                storeController?.setIsLoading(isLoading: false);
                storeController?.setListOfOrders(listOfOrders: []);
                Get.back();
              },
              title: Text(
                'Mis Compras Atenea',
                style: AppTextStyle.getOutfit500(
                    textSize: 20, textColor: AppColors.white),
              )),
          body: Stack(
            children: [
              Consumer<StoreController>(
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
                                          orderItem: storeController
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
              Consumer<StoreController>(
                  builder: (context, storeController, child) {
                    return Visibility(
                        visible: storeController.isLoading, child: LoadingLayout());
                  })
            ],
          ),
        ));
  }
}


class OrderHistoryWidget extends StatelessWidget {
  final OrderItem orderItem;

  const OrderHistoryWidget({super.key, required this.orderItem});

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
                orderItem.orderId ?? "",
                style: AppTextStyle.getOutfit400(
                    textSize: 18, textColor: AppColors.white),
              )),
              Text(
                DateFormat("dd-MM-yyyy").format(DateTime.parse(orderItem.date ?? "")),
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
                  label: 'Estado', value: orderItem.status ?? ""),
              SizedBox(
                height: 10,
              ),
              OrderRowWidget(label: 'Total', value: orderItem.total ?? ""),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: CustomButtonWidget(
                          buttonTitle: 'Albarán', onPressed: () async{

                        try{
                          if(await canLaunchUrl(Uri.parse(orderItem.invoiceLink ?? ""))){
                                await launchUrl(Uri.parse(orderItem.invoiceLink ?? ""));
                              }else{
                                AppConstants.showCustomToast(status: false, message: "Por favor, inténtalo de nuevo");
                              }
                            }catch(exception){
                              AppConstants.showCustomToast(status: false, message: "$exception");
                            }
                      })),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Consumer2<StoreController,StudentParentTeacherController>(
                        builder: (context,storeController,studentParentTeacherController,child){
                          return CustomButtonWidget(
                              buttonTitle: 'Ver', onPressed: () async{
                              Get.to(() => OrderDetailPage(orderNumber: orderItem.orderId?.split("#").last ?? "",));
                          });
                        },
                      )),
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

