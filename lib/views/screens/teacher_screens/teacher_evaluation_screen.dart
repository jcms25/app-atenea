import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/evaluation_list_model.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/dialog_boxes_widgets/no_observation_dialog_evaluation.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/class_menu_details_screen/evaluation_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/evaluation_report_world.dart';
import '../../../../services/api.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/evaluation_screen.dart';

class TeacherEvaluationScreen extends StatefulWidget {
  final String cid;
  final String wpId;
  final String studentName;

  const TeacherEvaluationScreen({
    super.key,
    required this.studentName,
    required this.cid,
    required this.wpId,
  });

  @override
  State<TeacherEvaluationScreen> createState() =>
      _TeacherEvaluationScreenState();
}

class _TeacherEvaluationScreenState extends State<TeacherEvaluationScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.setSelectedEvaluationYear(year: '');
      studentParentTeacherController?.setEvaluationClassName(className: '');
      studentParentTeacherController?.getEvaluation(
          classId: widget.cid, studentWpUserId: widget.wpId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController
              ?.setEvaluationItem(evaluationItem: []);
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
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Boletín de ${widget.studentName}',
                    maxLines: 1,
                    style: AppTextStyle.getOutfit500(
                        textSize: 20, textColor: AppColors.white),
                  ),
                  Consumer<StudentParentTeacherController>(
                    builder: (context, ctrl, child) {
                      if (ctrl.evaluationClassName.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return AutoSizeText(
                        '(${ctrl.evaluationClassName} ${ctrl.selectedEvaluationYear})',
                        maxLines: 1,
                        style: AppTextStyle.getOutfit400(
                            textSize: 12, textColor: AppColors.white),
                      );
                    },
                  ),
                ],
              ),
              actionIcons: [
                Consumer<StudentParentTeacherController>(
                  builder: (context, ctrl, child) {
                    return Visibility(
                        visible: ctrl.evaluationItem.isNotEmpty,
                        child: IconButton(
                            onPressed: () async {
                              try {
                                ctrl.setIsLoading(isLoading: true);
                                await Api.httpRequest(
                                        requestType: RequestType.get,
                                        endPoint:
                                            "${Api.evaluationPDFDownloadEndpoint}?student_id=${widget.wpId}&class_id=${widget.cid}&academic_year=${ctrl.selectedEvaluationYear}")
                                    .then((res) async {
                                  ctrl.setIsLoading(isLoading: false);
                                  if (res['status']) {
                                    String? pdfURL = res['PDFLink'];
                                    if (pdfURL != null && pdfURL.isNotEmpty) {
                                      if (mounted) {
                                        await launchUrl(Uri.parse(pdfURL));
                                      } else {
                                        AppConstants.showCustomToast(
                                            status: false,
                                            message: 'No se pudo recuperar');
                                      }
                                    } else {
                                      AppConstants.showCustomToast(
                                          status: false,
                                          message: 'No se pudo recuperar');
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
                    Consumer<StudentParentTeacherController>(
                      builder: (context, controller, child) {
                        if (controller.evaluationYears.length < 2) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          child: Row(
                            children: [
                              Text(
                                'Año Académico:',
                                style: AppTextStyle.getOutfit500(
                                    textSize: 14,
                                    textColor: AppColors.secondary),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.secondary, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButton<String>(
                                  value:
                                      controller.selectedEvaluationYear.isEmpty
                                          ? null
                                          : controller.selectedEvaluationYear,
                                  isDense: true,
                                  iconSize: 20,
                                  underline: const SizedBox.shrink(),
                                  items: controller.evaluationYears
                                      .map((year) => DropdownMenuItem<String>(
                                            value: year,
                                            child: Text(
                                              year,
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 14,
                                                  textColor:
                                                      AppColors.secondary),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null ||
                                        value ==
                                            controller.selectedEvaluationYear) {
                                      return;
                                    }
                                    controller.setSelectedEvaluationYear(
                                        year: value);
                                    controller.setEvaluationItem(
                                        evaluationItem: []);
                                    controller.getEvaluation(
                                        classId: widget.cid,
                                        studentWpUserId: widget.wpId,
                                        academicYear: value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Expanded(child: Consumer<StudentParentTeacherController>(
                      builder: (context, ctrl, child) {
                        return ctrl.evaluationItem.isEmpty
                            ? Center(
                                child: Text(
                                  'No se encontraron datos de evaluación.',
                                  style: AppTextStyle.getOutfit500(
                                      textSize: 18,
                                      textColor: AppColors.secondary),
                                ),
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
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
                                          columnWidths: const {
                                            0: FlexColumnWidth(4),
                                            1: FlexColumnWidth(1.5),
                                            2: FlexColumnWidth(1.5),
                                            3: FlexColumnWidth(1.5),
                                            4: FlexColumnWidth(1.5),
                                          },
                                          children: [
                                            TableRow(children: [
                                              LabelTableCell(
                                                  label: 'subjects'.tr),
                                              LabelTableCell(label: '1st'.tr),
                                              LabelTableCell(label: '2nd'.tr),
                                              LabelTableCell(label: '3rd'.tr),
                                              LabelTableCell(
                                                  label: 'final'.tr),
                                            ]),
                                            ...ctrl.evaluationItem.map((e) {
                                              return TableRow(children: [
                                                TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        e.subject,
                                                        style: AppTextStyle
                                                            .getOutfit400(
                                                                textSize: 16,
                                                                textColor: AppColors
                                                                    .secondary),
                                                      ),
                                                    )),
                                                DataCellWidget(
                                                    data: e.marks.evaluation1),
                                                DataCellWidget(
                                                    data: e.marks.evaluation2),
                                                DataCellWidget(
                                                    data: e.marks.evaluation3),
                                                DataCellWidget(
                                                    data: e.marks.evaluation4),
                                              ]);
                                            }),
                                            TableRow(children: [
                                              LabelTableCell(
                                                  label: 'obser'.tr),
                                              IconTableCell(onIconClick: () {
                                                _onObservationView(
                                                    evaluation: 1,
                                                    evaluationName: '1st'.tr,
                                                    evaluationItems:
                                                        ctrl.evaluationItem);
                                              }),
                                              IconTableCell(onIconClick: () {
                                                _onObservationView(
                                                    evaluation: 2,
                                                    evaluationName: '2nd'.tr,
                                                    evaluationItems:
                                                        ctrl.evaluationItem);
                                              }),
                                              IconTableCell(onIconClick: () {
                                                _onObservationView(
                                                    evaluation: 3,
                                                    evaluationName: '3rd'.tr,
                                                    evaluationItems:
                                                        ctrl.evaluationItem);
                                              }),
                                              IconTableCell(onIconClick: () {
                                                _onObservationView(
                                                    evaluation: 4,
                                                    evaluationName: 'final'.tr,
                                                    evaluationItems:
                                                        ctrl.evaluationItem);
                                              }),
                                            ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (ctrl.evaluationPromotion.isNotEmpty)
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 16),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: ctrl.evaluationPromotion == 'PRO'
                                            ? Colors.green.shade50
                                            : Colors.red.shade50,
                                        border: Border.all(
                                          color:
                                              ctrl.evaluationPromotion == 'PRO'
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            ctrl.evaluationPromotion == 'PRO'
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color:
                                                ctrl.evaluationPromotion == 'PRO'
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            ctrl.evaluationPromotion == 'PRO'
                                                ? 'Promociona al curso siguiente'
                                                : 'No promociona al curso siguiente',
                                            style: AppTextStyle.getOutfit500(
                                              textSize: 16,
                                              textColor:
                                                  ctrl.evaluationPromotion ==
                                                          'PRO'
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                      },
                    ))
                  ],
                ),
                Consumer<StudentParentTeacherController>(
                  builder: (context, ctrl, child) {
                    return Visibility(
                        visible: ctrl.isLoading,
                        child: LoadingLayout());
                  },
                )
              ],
            )));
  }

  void _onObservationView({
    required int evaluation,
    required String evaluationName,
    required List<EvaluationItem> evaluationItems,
  }) {
    List<EvaluationReport> evaluationReport = [];

    for (EvaluationItem e in evaluationItems) {
      Observation observation = e.observation;
      String evaluationRemark = evaluation == 1
          ? observation.observation1
          : evaluation == 2
              ? observation.observation2
              : evaluation == 3
                  ? observation.observation3
                  : observation.observation4;
      if (evaluationRemark.isEmpty) continue;
      evaluationReport.add(EvaluationReport(e.subject, evaluationRemark));
    }

    if (evaluationReport.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return NoObservationDialogEvaluationDialog();
          });
    } else {
      Get.to(EvaluationReportScreen(evaluationReport, evaluationName));
    }
  }
}