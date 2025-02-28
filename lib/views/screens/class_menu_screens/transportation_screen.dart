import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/dotted_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../controllers/student_parent_teacher_controller.dart';
import '../../../models/transport_list_model.dart';
import '../../custom_widgets/custom_loader.dart';

class TransportationScreen extends StatefulWidget {
  const TransportationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TransportScreenChild();
  }
}

class _TransportScreenChild extends State<TransportationScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController = Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getTransportData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (result, ct) {
          studentParentTeacherController?.setTransportItem(transportList: []);
          studentParentTeacherController?.setTempTransportList(transportList: []);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                titleSpacing: 0,
                elevation: 0,
                backgroundColor: AppColors.primary,
                title: Text(
                  "trans".tr,
                  style: AppTextStyle.getOutfit500(textSize: 20, textColor: AppColors.white),
                ),
                leading: Container(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AppImages.arrow,
                      colorFilter: const ColorFilter.mode(
                          AppColors.orange, BlendMode.srcIn),
                    ),
                  ),
                )),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 90,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: AppColors.primary),
                      child: Container(
                        // height: 50,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Consumer<StudentParentTeacherController>(
                          builder: (context, appController, child) {
                            return TextField(
                              maxLines: 1,
                              autofocus: false,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: AppColors.searchIcon,
                                  ),
                                  hintText: 'searchInList'.tr,
                                  hintStyle: AppTextStyle.getOutfit400(
                                      textSize: 16,
                                      // textColor:
                                      //     AppColors.secondary.withOpacity(0.5)
                                      // textColor: AppColors.secondary.withValues(alpha: 0.5)
                                      textColor: AppColors.secondary.withValues(alpha: 0.5)
                                  ),
                                  border: InputBorder.none),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onChanged: appController.searchInTransportData,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ScrollConfiguration(behavior: const ScrollBehavior().copyWith(overscroll: false), child: Consumer<StudentParentTeacherController>(
                        builder: (context, appController, child) {
                          return appController.tempTransportList.isEmpty
                              ? Center(
                            child: Text(
                              'noTransport'.tr,
                              style: AppTextStyle.getOutfit400(
                                  textSize: 16,
                                  textColor: AppColors.secondary),
                            ),
                          )
                              : ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (context, index) {
                              TransportItem item = appController
                                  .tempTransportList[index];
                              return Container(
                                padding: const EdgeInsets.all(10),
                                width:
                                MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    // color: AppColors.primary
                                    //     .withOpacity(0.05)
                                    color: AppColors.primary.withValues(alpha: 0.05)
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 25,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      child: Text(
                                        item.routeName,
                                        style: AppTextStyle.getOutfit400(textSize: 15, textColor: AppColors.white),
                                        // style: const TextStyle(
                                        //     color: AppColors.white,
                                        //     fontFamily: "Outfit",
                                        //     fontWeight: FontWeight.w400,
                                        //     fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTransportRow(
                                        label: 'vname'.tr,
                                        value: item.busName),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomDottedLineWidget(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTransportRow(
                                        label: 'dname'.tr,
                                        value: item.driverName),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomDottedLineWidget(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTransportRow(
                                        label: 'dnumber'.tr,
                                        value: item.phoneNo),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomDottedLineWidget(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTransportRow(
                                        label: 'rrate'.tr,
                                        value: item.routeFees),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomDottedLineWidget(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'vroute'.tr,
                                      style: AppTextStyle.getOutfit400(
                                          textSize: 16,
                                          // textColor: AppColors.secondary
                                          //     .withOpacity(0.5)
                                          textColor: AppColors.secondary.withValues(alpha: 0.5)
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      item.busRoute
                                          .replaceAll(' \n', '\n\n'),
                                      style: AppTextStyle.getOutfit400(
                                          textSize: 16,
                                          textColor:
                                          AppColors.secondary),
                                    )
                                  ],
                                ),
                              );
                            },
                            itemCount:
                            appController.tempTransportList.length,
                          );
                        },
                      )),
                    )),
                  ],
                ),
                Consumer<StudentParentTeacherController>(
                  builder: (context, appController, child) {
                    return Visibility(
                        visible: appController.isLoading,
                        child: Container(
                          // color: Colors.black.withOpacity(0.5),
                          color: AppColors.black.withValues(alpha: 0.5),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: LoadingLayout(),
                          ),
                        ));
                  },
                )
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class CustomTransportRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomTransportRow(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
          label,
          style: AppTextStyle.getOutfit400(
              textSize: 16,
              // textColor: AppColors.secondary.withOpacity(0.5)
              textColor: AppColors.secondary.withValues(alpha: 0.5)
          ),
        )),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          value,
          style: AppTextStyle.getOutfit400(
              textSize: 16, textColor: AppColors.secondary),
          textAlign: TextAlign.end,
        ))
      ],
    );
  }
}
