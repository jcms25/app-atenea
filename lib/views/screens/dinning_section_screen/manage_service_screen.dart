//Note : This is use for both parent and teacher and not for student.
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/dinning_manage_service_bottom_sheet_teacher.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class ManageServiceScreen extends StatefulWidget {
  const ManageServiceScreen({super.key});

  @override
  State<ManageServiceScreen> createState() => _ManageServiceScreenState();
}

class _ManageServiceScreenState extends State<ManageServiceScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1),(){
      if(!(Get.isBottomSheetOpen ?? false)){
        Get.bottomSheet(
            DinningManageServiceBottomSheetTeacher(
              currentLoggedInRole: studentParentTeacherController?.currentLoggedInUserRole == RoleType.parent
                  ? "parent"
                  : "teacher",
            )
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((res) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController?.setListOfStatusOfStudentDinning(
              listOfStatusOfStudentDinning: []);
          studentParentTeacherController
              ?.setMapOfStatusOfStudentDinning(mapOfStatusOfStudentDinning: {});
          studentParentTeacherController
              ?.setDinningStudentList(dinningStudentList: []);
          studentParentTeacherController?.setCurrentSelectedDinningDay(
              selectedDinningDay: null);
          studentParentTeacherController?.setCurrentSelectedDinningMonth(
              dinningMonth: null);
          studentParentTeacherController?.setDinningSettings(
              dinningSettings: null);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            onLeadingIconClicked: () {
              studentParentTeacherController?.setListOfStatusOfStudentDinning(
                  listOfStatusOfStudentDinning: []);
              studentParentTeacherController?.setMapOfStatusOfStudentDinning(
                  mapOfStatusOfStudentDinning: {});
              studentParentTeacherController
                  ?.setDinningStudentList(dinningStudentList: []);
              studentParentTeacherController?.setCurrentSelectedDinningDay(
                  selectedDinningDay: null);
              studentParentTeacherController?.setCurrentSelectedDinningMonth(
                  dinningMonth: null);
              studentParentTeacherController?.setDinningSettings(
                  dinningSettings: null);
              Get.back();
            },
            title: Text(
              'Gestionar Servicio',
              style: AppTextStyle.getOutfit500(
                  textSize: 20, textColor: AppColors.white),
            ),
            actionIcons: [
              DinningRoomAttendanceButton()
            ],
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacher, child) {
                      return Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                        ),
                        padding: const EdgeInsets.all(10).copyWith(bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: AppColors.transparent,
                                builder: (context) {
                                  return DinningManageServiceBottomSheetTeacher(
                                    currentLoggedInRole: studentParentTeacher
                                                .currentLoggedInUserRole ==
                                            RoleType.parent
                                        ? "parent"
                                        : "teacher",
                                  );
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(minHeight: 60),
                            child: Center(
                              child: Text(
                                "Gestionar",
                                style: AppTextStyle.getOutfit400(
                                    textSize: 16, textColor: AppColors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(child: Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacherController, child) {
                      return studentParentTeacherController
                              .dinningStudentList.isEmpty
                          ? Center(
                              child: Text(
                                'Filtrar datos de comedor',
                                style: AppTextStyle.getOutfit500(
                                    textSize: 16,
                                    textColor: AppColors.secondary),
                              ),
                            )
                          : ScrollConfiguration(
                              behavior:
                                  ScrollBehavior().copyWith(overscroll: false),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      Consumer<StudentParentTeacherController>(
                                        builder: (context, ctrl, child) {
                                          final Color accentColor = const Color(0xFF6c2e3e);
                                          final date = ctrl.selectedDinningDate;
                                          final closing = ctrl.dinningSettings?.closingTime ?? "-";
                                          final className = ctrl.currentLoggedInUserRole == RoleType.teacher
                                              ? ctrl.currentSelectedClass?.cName ?? ""
                                              : "";
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(text: TextSpan(
                                                  style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
                                                  children: [
                                                    const TextSpan(text: "Notificar asistencia a Comedor para el: "),
                                                    TextSpan(
                                                      text: "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: accentColor),
                                                    ),
                                                  ],
                                                )),
                                                const SizedBox(height: 6),
                                                RichText(text: TextSpan(
                                                  style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
                                                  children: [
                                                    const TextSpan(text: "Antes de esta hora: "),
                                                    TextSpan(
                                                      text: closing,
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: accentColor),
                                                    ),
                                                  ],
                                                )),
                                                if (className.isNotEmpty) ...[
                                                  const SizedBox(height: 6),
                                                  RichText(text: TextSpan(
                                                    style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
                                                    children: [
                                                      const TextSpan(text: "Para la clase: "),
                                                      TextSpan(
                                                        text: className,
                                                        style: TextStyle(fontWeight: FontWeight.bold, color: accentColor),
                                                      ),
                                                    ],
                                                  )),
                                                ],
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Table(
                                        columnWidths: {
                                          0: FlexColumnWidth(3),
                                          1: FlexColumnWidth(1),
                                          2: FlexColumnWidth(1),
                                        },
                                        border: TableBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          top: BorderSide(width: 1, color: AppColors.secondary),
                                          bottom: BorderSide(width: 1, color: AppColors.secondary),
                                          left: BorderSide(width: 1, color: AppColors.secondary),
                                          right: BorderSide(width: 1, color: AppColors.secondary),
                                          horizontalInside: BorderSide(color: AppColors.secondary, width: 1),
                                          verticalInside: BorderSide(color: AppColors.secondary, width: 1),
                                        ),
                                        children: [
                                          TableRow(children: [
                                            DinningHeaderTableCell(cellLabel: "student".tr),
                                            DinningHeaderTableCell(cellLabel: "Comedor"),
                                            DinningHeaderTableCell(cellLabel: "Asiste"),
                                          ]),
                                          ...studentParentTeacherController
                                              .dinningStudentList
                                              .map((e) {
                                            return TableRow(children: [
                                              TableCell(
                                                  child: Container(
                                                height: 60,
                                                padding: EdgeInsets.only(left: 10),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    e.studentName ?? "",
                                                    style: AppTextStyle.getOutfit500(
                                                        textSize: 16,
                                                        textColor: AppColors.secondary),
                                                  ),
                                                ),
                                              )),
                                              TableCell(
                                                  child: Container(
                                                height: 60,
                                                padding: EdgeInsets.only(left: 10),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Checkbox(
                                                      activeColor: AppColors.secondary,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5)),
                                                      value: e.diningProfile == 1 ? true : false,
                                                      onChanged: null),
                                                ),
                                              )),
                                              // Asiste
                                              TableCell(
                                                child: Container(
                                                  height: 60,
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Consumer<StudentParentTeacherController>(
                                                      builder: (context, ctrl, child) {
                                                        String currentRole = ctrl.currentLoggedInUserRole == RoleType.parent ? "parent" : "teacher";
                                                        String? senderRole = e.role;
                                                        bool canEdit = false;
                                                        DateTime now = DateTime.now();
                                                        DateTime today = DateTime(now.year, now.month, now.day);
                                                        DateTime selected = DateTime(
                                                            ctrl.selectedDinningDate.year,
                                                            ctrl.selectedDinningDate.month,
                                                            ctrl.selectedDinningDate.day);

                                                        // Lógica de permisos
                                                        if (selected.isBefore(today)) {
                                                          // Días pasados: no se puede editar
                                                          canEdit = false;
                                                        } else if (selected.isAfter(today)) {
                                                          // Días futuros: solo puede editar quien envió o si no hay envío
                                                          if (senderRole == null || senderRole.isEmpty) {
                                                            canEdit = true;  // Sin envío previo, cualquiera puede
                                                          } else if (senderRole == currentRole) {
                                                            canEdit = true;  // Mismo rol que envió, puede editar
                                                          } else {
                                                            canEdit = false; // Envío de otro rol, NO puede editar
                                                          }
                                                        } else {
                                                          // Día actual: verificar hora de cierre
                                                          bool isOpen = ctrl.dinningSettings?.checkClosingTime == "open";
                                                          bool isBeforeClosingTime = false;
                                                          
                                                          String? closingTime = ctrl.dinningSettings?.closingTime;
                                                          if (closingTime != null && closingTime.isNotEmpty && closingTime != "-") {
                                                            try {
                                                              List<String> parts = closingTime.split(':');
                                                              if (parts.length == 2) {
                                                                int closingHour = int.parse(parts[0]);
                                                                int closingMinute = int.parse(parts[1]);
                                                                
                                                                DateTime closingDateTime = DateTime(now.year, now.month, now.day, closingHour, closingMinute);
                                                                isBeforeClosingTime = now.isBefore(closingDateTime);
                                                              } else {
                                                                isBeforeClosingTime = true;
                                                              }
                                                            } catch (e) {
                                                              isBeforeClosingTime = true;
                                                            }
                                                          } else {
                                                            isBeforeClosingTime = true;
                                                          }
                                                          
                                                          if (!isOpen || !isBeforeClosingTime) {
                                                            canEdit = false;  // Fuera de horario
                                                          } else if (senderRole == null || senderRole.isEmpty) {
                                                            canEdit = true;   // Sin envío previo
                                                          } else if (senderRole == currentRole) {
                                                            canEdit = true;   // Mismo rol que envió
                                                          } else {
                                                            canEdit = false;  // Envío de otro rol
                                                          }
                                                        }

                                                        bool isChecked = ctrl.mapOfStatusOfStudentDinning[e.wpUsrId ?? ""] == 1;                                                                                                              
                                                        
                                                        Color getColorByRole(String? role) {
                                                          if (role == null) return Colors.grey;
                                                          if (role == 'parent') return Colors.red;
                                                          if (role == 'teacher') return Colors.green;
                                                          if (role == 'administrator') return Colors.blue;
                                                          return Colors.grey;
                                                        }
                                                        
                                                        Color checkboxColor = getColorByRole(senderRole);

                                                        return Checkbox(
                                                          activeColor: checkboxColor,
                                                          checkColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            side: BorderSide(width: 1.5, color: Colors.grey.shade600),
                                                          ),
                                                          value: isChecked,
                                                          onChanged: canEdit ? (bool? value) {
                                                            ctrl.addDinningStatusData(
                                                              keyName: e.wpUsrId ?? "",
                                                              status: value ?? false ? 1 : 0
                                                            );
                                                          } : null,
                                                          fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                                            if (isChecked) {
                                                              return checkboxColor;
                                                            }
                                                            return Colors.transparent;
                                                          }),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]);
                                          })
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ));
                    },
                  )),
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
          ),
        ));
  }
}

class DinningRoomAttendanceButton extends StatelessWidget {
  const DinningRoomAttendanceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentParentTeacherController>(
      builder: (context, studentParentTeacherController, child) {
        RoleType? currentLoggedInRole =
            studentParentTeacherController.currentLoggedInUserRole;
        return Visibility(
            visible: currentLoggedInRole == RoleType.teacher ||
                currentLoggedInRole == RoleType.parent,
            child: GestureDetector(
              onTap: () {
                DateTime now = DateTime.now();
                DateTime today = DateTime(now.year, now.month, now.day);
                DateTime selected = DateTime(
                    studentParentTeacherController.selectedDinningDate.year,
                    studentParentTeacherController.selectedDinningDate.month,
                    studentParentTeacherController.selectedDinningDate.day);
                
                bool canSend = false;

                String currentRole = currentLoggedInRole == RoleType.parent ? "parent" : "teacher";
                bool hasEditableStudents = studentParentTeacherController.dinningStudentList.any((e) => 
                    e.role == null || e.role!.isEmpty || e.role == currentRole);

                if (!hasEditableStudents && studentParentTeacherController.dinningStudentList.isNotEmpty) {
                    canSend = false;
                    // No hay nada que editar, salir
                    return;
                }

                if (selected.isAfter(today)) {
                  canSend = true;
                } else if (selected.isAtSameMomentAs(today)) {
                  bool isOpen = studentParentTeacherController.dinningSettings?.checkClosingTime == "open";
                  bool isBeforeClosingTime = false;
                  
                  String? closingTime = studentParentTeacherController.dinningSettings?.closingTime;
                  if (closingTime != null && closingTime.isNotEmpty && closingTime != "-") {
                    try {
                      List<String> parts = closingTime.split(':');
                      if (parts.length == 2) {
                        int closingHour = int.parse(parts[0]);
                        int closingMinute = int.parse(parts[1]);
                        
                        DateTime closingDateTime = DateTime(now.year, now.month, now.day, closingHour, closingMinute);
                        isBeforeClosingTime = now.isBefore(closingDateTime);
                      } else {
                        isBeforeClosingTime = true;
                      }
                    } catch (e) {
                      isBeforeClosingTime = true;
                    }
                  } else {
                    isBeforeClosingTime = true;
                  }
                  
                  canSend = isOpen && isBeforeClosingTime;
                } else {
                  canSend = false;
                }
                
                if (canSend) {
                    studentParentTeacherController.addEditDinningStatus();
                } else {
                    // Mostrar aviso de por qué está bloqueado
                    List<dynamic> bloqueados = studentParentTeacherController.dinningStudentList
                        .where((e) => e.role != null && e.role!.isNotEmpty && e.role != currentRole)
                        .toList();
                    if (bloqueados.isNotEmpty) {
                        String avisos = bloqueados.map((e) => "• ${e.studentName ?? ''}: notificado por ${e.role}").join("\n");
                        Get.dialog(AlertDialog(
                            title: Text("Registros bloqueados"),
                            content: Text(avisos),
                            actions: [TextButton(onPressed: () => Get.back(), child: Text("Entendido"))],
                        ));
                    }
                }
              },
              child: Container(
                height: 60,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: studentParentTeacherController
                                .dinningSettings?.checkClosingTime ==
                            "open"
                        ? AppColors.orange
                        : AppColors.orange.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    'Enviar',
                    style: AppTextStyle.getOutfit400(
                        textSize: 18,
                        textColor: studentParentTeacherController
                                    .dinningSettings?.checkClosingTime ==
                                "open"
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.5)
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}

class DinningHeaderTableCell extends StatelessWidget {
  final String cellLabel;

  const DinningHeaderTableCell({super.key, required this.cellLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          cellLabel,
          style: AppTextStyle.getOutfit500(
              textSize: 16, textColor: AppColors.white),
        ),
      ),
    );
  }
}