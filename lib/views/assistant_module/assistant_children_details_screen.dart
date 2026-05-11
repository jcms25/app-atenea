import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/assistant/assistant_child_detail_temp_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../views/custom_widgets/item_label_value.dart';
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
  String imagePath = "";

  @override
  void initState() {
    super.initState();
  }

  // Formatea "Apellidos Nombre" → "Apellidos, Nombre"
  String _formatName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length < 2) return fullName;
    // El nombre viene como "Apellido1 Apellido2 Nombre" o "Apellido Nombre"
    // Buscamos la última palabra como nombre y el resto como apellidos
    final firstName = parts.last;
    final lastNames = parts.sublist(0, parts.length - 1).join(' ');
    return '$lastNames, $firstName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'asChildDet'.tr,
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
                          _formatName(widget.tempChildModel.name),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.getOutfit600(textSize: 32, textColor: AppColors.secondary),
                        ),
                      ),
                      const SizedBox(height: 15),
                      LabelValueLayout(label: 'singalClass'.tr, value: widget.tempChildModel.className),
                      const SizedBox(height: 10),
                      LabelValueLayout(label: 'address'.tr, value: widget.tempChildModel.address),
                      const SizedBox(height: 10),
                      Text(
                        'parents'.tr,
                        style: AppTextStyle.getOutfit400(textSize: 18, textColor: AppColors.secondary.withValues(alpha: 0.75)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: widget.tempChildModel.parentsName.map((e) {
                          return Expanded(
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.only(left: 5),
                              child: AutoSizeText(
                                e.name,
                                style: AppTextStyle.getOutfit500(textSize: 18, textColor: AppColors.secondary),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
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
                    borderRadius: const BorderRadius.all(Radius.circular(160)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        spreadRadius: 0,
                        blurRadius: 25,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 16.0,
                    backgroundImage: NetworkImage(widget.tempChildModel.imagePath),
                    backgroundColor: AppColors.primary,
                    onBackgroundImageError: (e, s) {},
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
