import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../utils/app_images.dart';



class ItemLogoRounded extends StatelessWidget {
  const ItemLogoRounded({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(80),
              border: Border.all(color: AppColors.primary,width: 3,style: BorderStyle.solid),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowColor,
                  spreadRadius: 0,
                  blurRadius: 25,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Image.asset(
              AppImages.logo,
            ),
          )
      ),
    );
  }
}

class ItemWhiteOpacityCircle extends StatefulWidget {
  const ItemWhiteOpacityCircle({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ItemWhiteOpacityCircleState();
  }

}
class _ItemWhiteOpacityCircleState extends State<ItemWhiteOpacityCircle> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final AnimationController _controller2 = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  late final Animation<double> _animation2 = CurvedAnimation(
    parent: _controller2,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200)).then((value) => _controller.forward());
    _controller.addListener(() async{
      if (_controller.isCompleted) {
        await Future.delayed(const Duration(milliseconds: 200));
        _controller2.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: _animation2,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.03),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(160),
                topRight: Radius.circular(160),
                bottomLeft: Radius.circular(160),
                bottomRight: Radius.circular(160),
              ),
            ),
          ),
        ),
        ScaleTransition(
          scale: _animation,
          child: Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(115),
                topRight: Radius.circular(115),
                bottomLeft: Radius.circular(115),
                bottomRight: Radius.circular(115),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

