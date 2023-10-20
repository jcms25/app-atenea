import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/assistant/assistant_child_detail_temp_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widgets/item_label_value.dart';
import '../../utils/app_colors.dart';

class ChildDetail extends StatefulWidget {
  final TempChildModel tempChildModel;

  const ChildDetail(this.tempChildModel, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ChildDetailScreen();
  }
}

class ChildDetailScreen extends State<ChildDetail> {

  TextStyle txtLabelStyle = TextStyle(
      color: AppColors.secondary.withOpacity(0.75),
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w400,
      fontSize: 18);
  TextStyle txtValueStyle = const TextStyle(
        color: AppColors.secondary,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w500,
      fontSize: 18);

  String imagePath = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'asChildDet'.tr,
          style: const TextStyle(
            fontFamily: "Outfit",
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: Container(
                  color: AppColors.white,
                ),
              )
            ],
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  margin: const EdgeInsets.only(top: 100, bottom: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.tempChildModel.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                              color: AppColors.secondary),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      LabelValueLayout(label: "address".tr, value: widget.tempChildModel.address),
                      const SizedBox(height: 10,),
                      // LabelValueLayout(label: "workingHours".tr, value: "12-00"),
                      // const SizedBox(height: 10,),
                      Text("parent".tr,style: TextStyle(
                          color: AppColors.secondary.withOpacity(0.75),
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w400,
                          fontSize: 18),),
                      const SizedBox(height: 10,),
                      // Row(
                      //   children: [
                      //     Expanded(child:
                      //     Container(
                      //       height: 60,
                      //       padding: const EdgeInsets.symmetric(horizontal: 15),
                      //       alignment: Alignment.centerLeft,
                      //       decoration: BoxDecoration(
                      //         color: AppColors.secondary.withOpacity(0.06),
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //       child: Text(
                      //         "parent1",
                      //         style: txtValueStyle,
                      //       ),
                      //     )),
                      //     const SizedBox(width: 10,),
                      //     Expanded(child:  Container(
                      //       height: 60,
                      //       padding: const EdgeInsets.symmetric(horizontal: 15),
                      //       alignment: Alignment.centerLeft,
                      //       decoration: BoxDecoration(
                      //         color: AppColors.secondary.withOpacity(0.06),
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //       child: Text(
                      //         "parent2",
                      //         style: txtValueStyle,
                      //       ),
                      //     )),
                      //   ],
                      // ),
                      Row(
                        children: widget.tempChildModel.parentsName.map((e){
                          return  Expanded(
                              child: Container(
                                height: 60,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.only(left: 5),
                                child: AutoSizeText(
                                  e.name,
                                  style: txtValueStyle,
                                ),
                              ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10,),
                      LabelValueLayout(label: "singalClass".tr, value: widget.tempChildModel.className),
                      const SizedBox(height: 10,),

                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                        color: AppColors.primary,
                        width: 3.0,
                        style: BorderStyle.solid),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(160)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 25,
                        offset: const Offset(
                            0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 16.0,
                    backgroundImage: NetworkImage(widget.tempChildModel.imagePath),
                    backgroundColor: AppColors.primary,
                    onBackgroundImageError: (e,s){},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
