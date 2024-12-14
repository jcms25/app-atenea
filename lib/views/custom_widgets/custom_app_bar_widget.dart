import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? leadingIcon;
  final VoidCallback? onLeadingIconClicked;
  final Widget title;
  final List<Widget>? actionIcons;
  final bool? showLeadingIcon;

  const CustomAppBarWidget(
      {super.key,
      this.leadingIcon,
      required this.title,
      this.actionIcons,
      this.onLeadingIconClicked,
      this.showLeadingIcon});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Container(
          height: preferredSize.height,
          color: AppColors.primary,
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              showLeadingIcon != null && showLeadingIcon == false
                  ? const SizedBox.shrink()
                  : leadingIcon != null
                      ? GestureDetector(
                          onTap: onLeadingIconClicked ??
                              () {
                                Get.back();
                              },
                          child: SvgPicture.asset(leadingIcon ?? ""),
                        )
                      : GestureDetector(
                          onTap: onLeadingIconClicked,
                          child: SvgPicture.asset(
                            AppImages.arrow,
                            width: 40,
                            height: 40,
                            colorFilter: const ColorFilter.mode(
                                AppColors.orange, BlendMode.srcIn),
                          ),
                        ),
              const SizedBox(
                width: 10,
              ),
              Expanded(child: title),
              ...actionIcons?.map((e) {
                    return e;
                  }).toList() ??
                  [],
              const SizedBox(width: 10,)
            ],
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
