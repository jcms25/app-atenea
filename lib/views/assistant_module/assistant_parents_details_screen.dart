import 'package:colegia_atenea/models/assistant/assistant_child_list_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_textstyle.dart';
import '../../views/custom_widgets/item_label_value.dart';
import '../../utils/app_colors.dart';

class AssistantParentDetails extends StatefulWidget{
  final ParentDatum parentDatum;

  const AssistantParentDetails(this.parentDatum, {super.key});

  @override
  State<StatefulWidget> createState() {
    return AssistantParentDetailsChild();
  }

}

class AssistantParentDetailsChild extends State<AssistantParentDetails> {
  // bool _isLoading = false;
  TextStyle txtLabelStyle = TextStyle(
      // color: AppColors.secondary.withOpacity(0.75),
      color: AppColors.secondary.withValues(alpha: 0.75),
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
          'asPareDet'.tr,
          style: AppTextStyle.getOutfit500(textSize: 19, textColor: AppColors.white),
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
                          widget.parentDatum.parentName,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.getOutfit600(textSize: 32, textColor: AppColors.secondary),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      LabelValueLayout(label: "address".tr, value: widget.parentDatum.sPaddress),
                      const SizedBox(height: 10,),
                      LabelValueLayout(label: "phoneNumber".tr, value: widget.parentDatum.pPhone),
                      const SizedBox(height: 10,),
                      LabelValueLayout(label: "emailAdd".tr, value: widget.parentDatum.pEmail),
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
                        // color: AppColors.primary.withOpacity(0.5),
                        color: AppColors.primary.withValues(alpha: 0.5),
                        spreadRadius: 0,
                        blurRadius: 25,
                        offset: const Offset(
                            0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 16.0,
                    backgroundImage: NetworkImage(widget.parentDatum.parentImage),
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