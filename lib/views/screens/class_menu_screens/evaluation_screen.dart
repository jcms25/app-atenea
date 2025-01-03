import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/evaluation_list_model.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/dialog_boxes_widgets/no_observation_dialog_evaluation.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/class_menu_details_screen/evaluation_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/evaluation_report_world.dart';
import '../../../services/api.dart';

class EvaluationScreen extends StatefulWidget {
  final String cid;
  final String wpId;
  final String studentName;

  const EvaluationScreen({
    super.key,
    required this.studentName,
    required this.cid,
    required this.wpId,
  });

  @override
  TableExample createState() => TableExample();
}

class TableExample extends State<EvaluationScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getEvaluation(
          classId: widget.cid, studentWpUserId: widget.wpId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController?.setEvaluationItem(evaluationItem: []);
          studentParentTeacherController?.setIsLoading(isLoading: false);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBarWidget(
              onLeadingIconClicked: () {
                studentParentTeacherController
                    ?.setEvaluationItem(evaluationItem: []);
                studentParentTeacherController?.setIsLoading(isLoading: false);
                Get.back();
              },
              title: AutoSizeText(
                "Informe de Evaluación de ${widget.studentName}",
                maxLines: 1,
                style: AppTextStyle.getOutfit500(
                    textSize: 20, textColor: AppColors.white),
              ),
              actionIcons: [
                Consumer<StudentParentTeacherController>(
                  builder: (context, studentParentTeacherController, child) {
                    return Visibility(
                        visible: studentParentTeacherController
                            .evaluationItem.isNotEmpty,
                        child: IconButton(
                            onPressed: () async {
                              try {
                                 studentParentTeacherController.setIsLoading(isLoading: true);
                                await Api.httpRequest(requestType: RequestType.get, endPoint: "${Api.evaluationPDFDownloadEndpoint}?student_id=${widget.wpId}&class_id=${widget.cid}").then((res) async{
                                  studentParentTeacherController.setIsLoading(isLoading: false);
                                  if(res['status']){
                                    String? pdfURL = res['PDFLink'];
                                    if(pdfURL != null || pdfURL != ""){
                                      if(mounted){
                                        await launchUrl(Uri.parse(pdfURL ?? ""));
                                      }else{
                                        AppConstants.showCustomToast(status: false, message: 'No se pudo recuperar');
                                      }
                                    }else{
                                      AppConstants.showCustomToast(status: false, message: 'No se pudo recuperar');
                                    }
                                  }
                                });
                              } catch (e) {
                                AppConstants.showCustomToast(
                                    status: false, message: "$e");
                              }
                            },
                            icon: const Icon(
                              Icons.download,
                              color: AppColors.white,
                            )));
                  },
                )
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: Consumer<StudentParentTeacherController>(
                      builder: (context, studentParentController, child) {
                        return studentParentController.evaluationItem.isEmpty
                            ? Center(
                                child: Text(
                                  'No se encontraron datos de evaluación.',
                                  style: AppTextStyle.getOutfit500(
                                      textSize: 18,
                                      textColor: AppColors.secondary),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Table(
                                    border: TableBorder(
                                        verticalInside: BorderSide(
                                            width: 1,
                                            color: AppColors.secondary),
                                        horizontalInside: BorderSide(
                                            width: 1,
                                            color: AppColors.secondary),
                                        top: BorderSide(
                                            width: 1,
                                            color: AppColors.secondary),
                                        bottom: BorderSide(
                                            width: 1,
                                            color: AppColors.secondary),
                                        left: BorderSide(
                                            width: 1,
                                            color: AppColors.secondary),
                                        right: BorderSide(
                                            width: 1,
                                            color: AppColors.secondary)),
                                    columnWidths: {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(2),
                                    },
                                    children: [
                                      TableRow(children: [
                                        LabelTableCell(label: 'subjects'.tr),
                                        LabelTableCell(label: '1st'.tr),
                                        LabelTableCell(label: '2nd'.tr),
                                        LabelTableCell(label: '3rd'.tr),
                                        LabelTableCell(label: 'final'.tr),
                                      ]),
                                      ...studentParentController.evaluationItem
                                          .map((e) {
                                        return TableRow(children: [
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Text(
                                                  e.subject,
                                                  style:
                                                      AppTextStyle.getOutfit400(
                                                          textSize: 16,
                                                          textColor: AppColors
                                                              .secondary),
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Text(
                                                  e.marks.evaluation1,
                                                  style:
                                                      AppTextStyle.getOutfit400(
                                                          textSize: 16,
                                                          textColor: AppColors
                                                              .secondary),
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Text(
                                                  e.marks.evaluation2,
                                                  style:
                                                      AppTextStyle.getOutfit400(
                                                          textSize: 16,
                                                          textColor: AppColors
                                                              .secondary),
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Text(
                                                  e.marks.evaluation3,
                                                  style:
                                                      AppTextStyle.getOutfit400(
                                                          textSize: 16,
                                                          textColor: AppColors
                                                              .secondary),
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Text(
                                                  e.marks.evaluation4,
                                                  style:
                                                      AppTextStyle.getOutfit400(
                                                          textSize: 16,
                                                          textColor: AppColors
                                                              .secondary),
                                                ),
                                              )),
                                        ]);
                                      }),
                                      TableRow(children: [
                                        LabelTableCell(label: "obser".tr),
                                        IconTableCell(onIconClick: () {
                                            onObservationView(evaluation: 1, evaluationName: '1st'.tr, evaluationItems: studentParentController.evaluationItem);
                                        }),
                                        IconTableCell(onIconClick: () {
                                          onObservationView(evaluation: 2, evaluationName: '2nd'.tr, evaluationItems: studentParentController.evaluationItem);
                                        }),
                                        IconTableCell(onIconClick: () {
                                          onObservationView(evaluation: 3, evaluationName: '3rd'.tr, evaluationItems: studentParentController.evaluationItem);
                                        }),
                                        IconTableCell(onIconClick: () {
                                          onObservationView(evaluation: 4, evaluationName: 'final'.tr, evaluationItems: studentParentController.evaluationItem);
                                        }),
                                      ]),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ))
                  ],
                ),
                Consumer<StudentParentTeacherController>(
                  builder: (context, studentParentTeacherController, child) {
                    return Visibility(
                        visible: studentParentTeacherController.isLoading,
                        child: LoadingLayout());
                  },
                )
              ],
            )));
  }


  void onObservationView({required int evaluation,required String evaluationName,required List<EvaluationItem> evaluationItems}) {
   List<EvaluationReport> evaluationReport = [];

   for(EvaluationItem e in evaluationItems){
      Observation observation = e.observation;
      String evaluationRemark =  evaluation == 1 ? observation.observation1 : evaluation == 2 ? observation.observation2 : evaluation == 3 ? observation.observation3 : observation.observation4;
      if(evaluationRemark.isEmpty){
        continue;
      }else{
        evaluationReport.add(EvaluationReport(e.subject, evaluationRemark));
      }
   }

   if(evaluationReport.isEmpty){
     showDialog(context: context, builder: (context){
       return NoObservationDialogEvaluationDialog();
     });
   }else{
     Get.to(EvaluationReportScreen(evaluationReport, evaluationName));
   }


  }
}

// void onclick(int evaluation, String evaluationName) {
//   List<EvaluationReport> evolutionReport = [];
//   for (int i = 0; i < evaluationList.length; i++) {
//     String evaluationRemark = evaluation == 1
//         ? evaluationList[i].observation.observation1
//         : evaluation == 2
//             ? evaluationList[i].observation.observation2
//             : evaluation == 3
//                 ? evaluationList[i].observation.observation3
//                 : evaluationList[i].observation.observation4;
//     if (evaluationRemark.isEmpty) {
//       continue;
//     } else {
//       evolutionReport
//           .add(EvaluationReport(evaluationList[i].subject, evaluationRemark));
//     }
//   }
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               EvaluationReportScreen(evolutionReport, evaluationName)));
// }

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)))),
    child: Text(
      "OK",
      style: CustomStyle.txtvalue2,
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),

    //title:
    content: const Text("NO HAY OBSERVACIONES PARA ESTA EVALUACIÓN"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class LabelTableCell extends StatelessWidget {
  final String label;

  const LabelTableCell({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          height: 60,
          color: AppColors.primary,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTextStyle.getOutfit400(
                  textSize: 16, textColor: AppColors.white),
            ),
          ),
        ));
  }
}

class IconTableCell extends StatelessWidget {
  final VoidCallback onIconClick;

  const IconTableCell({super.key, required this.onIconClick});

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Container(
      height: 60,
      color: AppColors.primary,
      child: Align(
        alignment: Alignment.center,
        child: IconButton(
            onPressed: onIconClick,
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: AppColors.white,
            )),
      ),
    ));
  }
}
