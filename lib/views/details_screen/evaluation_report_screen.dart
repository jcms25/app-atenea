import 'package:colegia_atenea/models/Evaluationreportmodel.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EvaluationReportScreen extends StatefulWidget {
  final List<Evaluationreport> evolutionReport;
  final String evaluation;

  const EvaluationReportScreen(this.evolutionReport, this.evaluation, {super.key});

  @override
  State<EvaluationReportScreen> createState() => _EvaluationReportScreenChild();
}

class _EvaluationReportScreenChild extends State<EvaluationReportScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: Text("ER".tr, style: CustomStyle.appBarTitle),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.arrow,
                  color: AppColors.orange,
                ),
              ),
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Image.asset(AppImages.document),
            )),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Observaciones de la ",
                          style: CustomStyle.textValue.copyWith(fontSize: 20)),
                      TextSpan(
                          text: widget.evaluation,
                          style: const TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w400,
                              fontSize: 20)),
                      TextSpan(
                          text: " Evaluacion",
                          style: CustomStyle.textValue.copyWith(fontSize: 20)),
                    ]))),
            widget.evolutionReport.isEmpty
                ? Expanded(
                    child: Center(
                    child: Text(
                      "ObservationEmpty".tr,
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ))
                : Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.05),
                          width: 2,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.evolutionReport.length,
                          itemBuilder: (context, position) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.evolutionReport[position].subject,
                                      style: CustomStyle.txtvalue3),
                                  CustomStyle.dottedLine,
                                  Text(
                                      widget.evolutionReport[position]
                                          .observation,
                                      style: CustomStyle.txtvalue3_1),
                                  CustomStyle.dottedLine
                                ],
                              ),
                            );
                          }),
                    ),
                  )
          ],
        ));
  }
}
