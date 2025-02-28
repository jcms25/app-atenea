import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool? isObscure;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatter;
  final Function validateFunction;
  final Function(String?)? onTextChanged;
  final int? minLine;
  final int? maxLine;
  final String? label;
  final Color? filledColor;
  final Icon? prefixIcon;
  final bool? enabled;

  CustomTextField(
      {super.key,
      this.controller,
      this.isObscure,
      this.suffixIcon,
      this.hintText,
      this.textInputAction,
      this.textInputType,
      required this.validateFunction,
      this.onTextChanged,
      this.minLine,
      this.maxLine,
      this.filledColor,
      this.prefixIcon,
      this.enabled,
      this.inputFormatter,
      this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: label != null,
            child: Text(
              label ?? "",
              style: AppTextStyle.getOutfit400(
                  textSize: 18, textColor: AppColors.secondary),
            )
        ),
        Visibility(
            visible: label != null,
            child: const SizedBox(
              height: 10,
            )),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
              filled: true,
              border: inputBorder,
              focusedBorder: inputBorder,
              errorBorder: inputBorder,
              focusedErrorBorder: inputBorder,
              enabledBorder: inputBorder,
              disabledBorder: inputBorder,
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: AppTextStyle.getOutfit500(
                  textSize: 18,
                  // textColor: AppColors.secondary.withOpacity(0.4)
                  textColor: AppColors.secondary.withValues(alpha: 0.4)
              ),
              // fillColor: filledColor ?? AppColors.secondary.withOpacity(0.06)
              fillColor: filledColor ?? AppColors.secondary.withValues(alpha: 0.06)
          ),
          minLines: minLine,
          obscureText: isObscure != null ? !isObscure! : false,
          maxLines: maxLine ?? minLine ?? 0 + 1,
          onChanged: onTextChanged,
          keyboardType: textInputType,
          inputFormatters: inputFormatter,
          autofocus: false,
          textInputAction: textInputAction,
          validator: (value) => validateFunction(value),
        )
      ],
    );
  }

  final InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none);
}
