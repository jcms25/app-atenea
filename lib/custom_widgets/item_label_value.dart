import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';

class LabelValueLayout extends StatelessWidget {
  String label, value;
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

  LabelValueLayout({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: txtLabelStyle),
        const SizedBox(
          height: 10,
        ),
        label == "address".tr
            ? Container(
          padding:
          const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "404, Kala Sagar Mall, Opp Sai Temple, Sattdhar Cross Road, Ghatlodia",
            style: txtValueStyle,
          ),
        )
            : Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: txtValueStyle,
          ),
        ),
      ],
    );
  }
}