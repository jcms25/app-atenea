import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EvaluationIniScreen extends StatefulWidget {
  final String studentName;
  final String wpId;

  const EvaluationIniScreen({
    super.key,
    required this.studentName,
    required this.wpId,
  });

  @override
  State<EvaluationIniScreen> createState() => _EvaluationIniScreenState();
}

class _EvaluationIniScreenState extends State<EvaluationIniScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.setEvaluationIniItems(items: []);
      studentParentTeacherController?.getEvaluationIni(
          studentWpUserId: widget.wpId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (res, ctx) {
        studentParentTeacherController?.setEvaluationIniItems(items: []);
        studentParentTeacherController?.setIsLoading(isLoading: false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            studentParentTeacherController?.setEvaluationIniItems(items: []);
            studentParentTeacherController?.setIsLoading(isLoading: false);
            Get.back();
          },
          title: AutoSizeText(
            widget.studentName.isEmpty
                ? "Evaluación Inicial"
                : "Evaluación Inicial de ${widget.studentName}",
            maxLines: 1,
            style: AppTextStyle.getOutfit500(
                textSize: 20, textColor: AppColors.white),
          ),
        ),
        body: Stack(
          children: [
            Consumer<StudentParentTeacherController>(
              builder: (context, controller, child) {
                if (controller.evaluationIniItems.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No hay resultados de Evaluación Inicial disponibles.',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.getOutfit500(
                            textSize: 18, textColor: AppColors.secondary),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.evaluationIniItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.evaluationIniItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.subject,
                              style: AppTextStyle.getOutfit600(
                                  textSize: 18, textColor: AppColors.primary),
                            ),
                            if (item.topic.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                item.topic,
                                style: AppTextStyle.getOutfit400(
                                    textSize: 15,
                                    textColor: AppColors.secondary),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Text(
                              'Calificación: ${item.mark}',
                              style: AppTextStyle.getOutfit500(
                                  textSize: 16, textColor: AppColors.secondary),
                            ),
                            if (item.remark.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                'Observaciones: ${item.remark}',
                                style: AppTextStyle.getOutfit400(
                                    textSize: 15,
                                    textColor: AppColors.secondary),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Consumer<StudentParentTeacherController>(
              builder: (context, controller, child) {
                return Visibility(
                    visible: controller.isLoading, child: LoadingLayout());
              },
            ),
          ],
        ),
      ),
    );
  }
}