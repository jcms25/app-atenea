import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class BackgroundLayout extends StatelessWidget {
  final String image;
  final int imageType;
  final Widget childWidget; //0 asset image,1 network image
  final Widget? loadingWidget;
  final Widget? circularImage;

  const BackgroundLayout(
      {super.key,
      required this.image,
      required this.imageType,
      required this.childWidget,
      this.loadingWidget, this.circularImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                      color: AppColors.primary,
                    )),
                Expanded(
                    child: Container(
                      color: AppColors.white,
                    ))
              ],
            ),
            ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.sizeOf(context).height * 0.20,
                        ),
                        decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                        padding: const EdgeInsets.only(top: 80, right: 15, left: 15),
                        child: childWidget,
                      ),
                      Visibility(
                          visible: circularImage != null,
                          child: circularImage ?? const SizedBox.shrink()
                      ),
                    ],
                  ),
                )),
            loadingWidget ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
