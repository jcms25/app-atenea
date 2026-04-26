import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/events_list.dart';
import 'package:colegia_atenea/models/teacher/teacher_class_model.dart';
import 'package:colegia_atenea/models/student_list_model.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';

class TeacherAddEditEvents extends StatefulWidget {
  const TeacherAddEditEvents({super.key});

  @override
  State<TeacherAddEditEvents> createState() => _TeacherAddEditEventState();
}

class _TeacherAddEditEventState extends State<TeacherAddEditEvents> {
  final GlobalKey<FormState> _eventKey = GlobalKey<FormState>();
  StudentParentTeacherController? studentParentTeacherController;
  Map<String, dynamic>? arguments;
  EventListItemDetail? eventListItemDetail;

  TextEditingController? titleController;
  TextEditingController? descriptionController;
  String _notifyTo = 'none';
  TeacherClassItem? _selectedClass;
  StudentItem? _selectedStudent;

  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
    eventListItemDetail = arguments?['event-data'];
    titleController = TextEditingController(text: eventListItemDetail?.title);
    descriptionController =
        TextEditingController(text: eventListItemDetail?.description);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      DateTime? startDateTime = eventListItemDetail?.startDate;
      TimeOfDay? startTime = startDateTime != null
          ? TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute)
          : null;

      DateTime? endDateTime = eventListItemDetail?.endDate;
      TimeOfDay? endTime = endDateTime != null
          ? TimeOfDay(hour: endDateTime.hour, minute: endDateTime.minute)
          : null;

      // Cargar lista de clases del profesor si no está disponible
      if (studentParentTeacherController?.listOfClassAssignToTeacher.isEmpty ?? true) {
        studentParentTeacherController?.getListOfClassesAssignToTeacher(showLoader: false);
      }
      studentParentTeacherController?.setSelectedEventStartDate(
          date: startDateTime);
      studentParentTeacherController?.setSelectedEventEndDate(date: endDateTime);
      studentParentTeacherController?.setSelectedStartTime(
          startTime: startTime);
      studentParentTeacherController?.setSelectedEndTime(endTime: endTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController?.setIsLoading(isLoading: false);
          studentParentTeacherController?.clearAddEditEventScreen();
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
              onLeadingIconClicked: () {
                studentParentTeacherController?.setIsLoading(isLoading: false);
                studentParentTeacherController?.clearAddEditEventScreen();
                Get.back();
              },
              title: Text(
                arguments?['reason'] == 'add-event'
                    ? "Agregar evento"
                    : "Editar evento",
                style: AppTextStyle.getOutfit600(
                    textSize: 20, textColor: AppColors.white),
              )),
          body: Stack(
            children: [
              ScrollConfiguration(
                  behavior: ScrollBehavior().copyWith(overscroll: false),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha de inicio',
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          DateTime? startDate =
                                              await studentParentTeacherController
                                                  .pickDate();
                                          studentParentTeacherController
                                              .setSelectedEventStartDate(
                                                  date: startDate);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // color: AppColors.secondary
                                              //     .withOpacity(0.06)
                                              color: AppColors.secondary.withValues(alpha: 0.06)
                                          ),
                                          child: Center(
                                            child: Text(
                                              studentParentTeacherController
                                                          .eventStartDate ==
                                                      null
                                                  ? "Fecha de inicio"
                                                  : DateFormat("dd-MM-yyyy").format(
                                                      studentParentTeacherController
                                                              .eventStartDate ??
                                                          DateTime.now()),
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 16,
                                                  textColor:
                                                      AppColors.secondary),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha de finalización',
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          DateTime? endDate =
                                              await studentParentTeacherController
                                                  .pickDate(
                                                      startDate:
                                                          studentParentTeacherController
                                                              .eventStartDate);
                                          studentParentTeacherController
                                              .setSelectedEventEndDate(
                                                  date: endDate);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // color: AppColors.secondary
                                              //     .withOpacity(0.06)
                                            color: AppColors.secondary.withValues(alpha: 0.06)
                                          ),
                                          child: Center(
                                            child: Text(
                                              studentParentTeacherController
                                                          .eventEndDate ==
                                                      null
                                                  ? "Fecha de finalización"
                                                  : DateFormat("dd-MM-yyyy").format(
                                                      studentParentTeacherController
                                                              .eventEndDate ??
                                                          DateTime.now()),
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 16,
                                                  textColor:
                                                      AppColors.secondary),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hora inicial',
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? timeOfDay =
                                              await studentParentTeacherController
                                                  .pickTime();
                                          studentParentTeacherController
                                              .setSelectedStartTime(
                                                  startTime: timeOfDay);
                                        },
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // color: AppColors.secondary
                                              //     .withOpacity(0.06)
                                            color: AppColors.secondary.withValues(alpha: 0.06)
                                          ),
                                          child: Center(
                                            child: Text(
                                              studentParentTeacherController.startTime == null ? "00:00" : getTimeInFormat(studentParentTeacherController.startTime!),
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 16,
                                                  textColor:
                                                      AppColors.secondary),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hora final',
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Consumer<StudentParentTeacherController>(
                                    builder: (context,
                                        studentParentTeacherController, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? timeOfDay =
                                              await studentParentTeacherController
                                                  .pickTime();
                                          studentParentTeacherController
                                              .setSelectedEndTime(
                                                  endTime: timeOfDay);
                                        },
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // color: AppColors.secondary
                                              //     .withOpacity(0.06)
                                            color: AppColors.secondary.withValues(alpha: 0.06)
                                          ),
                                          child: Center(
                                            child: Text(
                                              // "${studentParentTeacherController.endTime?.hour ?? "--"}\t\t:\t\t${studentParentTeacherController.endTime?.minute ?? "--"}",
                                              studentParentTeacherController.endTime == null ? "00:00" : getTimeInFormat(studentParentTeacherController.endTime!),
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 16,
                                                  textColor:
                                                      AppColors.secondary),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Form(
                              key: _eventKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Event title
                                  Text(
                                    'Titulo',
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextField(
                                    controller: titleController,
                                    validateFunction: (String? value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.trim().isEmpty) {
                                        return "Por favor ingrese una descripción";
                                      }
                                      return null;
                                    },
                                    hintText: "Introducir título",
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  //Event Description
                                  Text(
                                    'Descripcion',
                                    style: AppTextStyle.getOutfit500(
                                        textSize: 18,
                                        textColor: AppColors.secondary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextField(
                                    controller: descriptionController,
                                    minLine: 7,
                                    validateFunction: (String? value) {
                                      // if (value == null ||
                                      //     value.isEmpty ||
                                      //     value.trim().isEmpty) {
                                      //   return "Por favor ingrese una descripción";
                                      // }
                                      // return null;
                                    },
                                    hintText: "Introducir descripción",
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              )),

                          //event type
                          Text(
                            'Tipo',
                            style: AppTextStyle.getOutfit500(
                                textSize: 18, textColor: AppColors.secondary),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                // color: AppColors.secondary.withOpacity(0.06)
                              color: AppColors.secondary.withValues(alpha: 0.06)
                            ),
                            child: Consumer<StudentParentTeacherController>(
                              builder: (context, studentParentTeacherController,
                                  child) {
                                return DropdownButton<EventTypeModel>(
                                    underline: const SizedBox.shrink(),
                                    isExpanded: true,
                                    value: studentParentTeacherController
                                        .selectedEventType,
                                    items: AppConstants.eventTypeList.map((e) {
                                      return DropdownMenuItem<EventTypeModel>(
                                          value: e,
                                          child: Text(
                                            e.eventType,
                                            style: AppTextStyle.getOutfit500(
                                                textSize: 16,
                                                textColor: AppColors.secondary),
                                          ));
                                    }).toList(),
                                    onChanged:
                                        (EventTypeModel? eventTypeModel) {
                                      studentParentTeacherController
                                          .setSelectedEventType(
                                              eventTypeModel: eventTypeModel);
                                    });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // Notificar a
                          Text(
                            'Notificar a',
                            style: AppTextStyle.getOutfit500(
                                textSize: 18, textColor: AppColors.secondary),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.secondary.withValues(alpha: 0.06)),
                            child: DropdownButton<String>(
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              value: _notifyTo,
                              items: const [
                                DropdownMenuItem(value: 'none',    child: Text('Sin notificación')),
                                DropdownMenuItem(value: 'all',     child: Text('Todos los alumnos y sus padres')),
                                DropdownMenuItem(value: 'class',   child: Text('Un grupo de clase')),
                                DropdownMenuItem(value: 'student', child: Text('Un alumno específico')),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  _notifyTo = value ?? 'none';
                                  _selectedClass = null;
                                  _selectedStudent = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Selector de clase
                          if (_notifyTo == 'class')
                            Consumer<StudentParentTeacherController>(
                              builder: (context, ctrl, child) {
                                return Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.secondary.withValues(alpha: 0.06)),
                                  child: DropdownButton<TeacherClassItem>(
                                    underline: const SizedBox.shrink(),
                                    isExpanded: true,
                                    hint: const Text('Selecciona una clase'),
                                    value: _selectedClass,
                                    items: ctrl.listOfClassAssignToTeacher.map((e) {
                                      return DropdownMenuItem<TeacherClassItem>(
                                        value: e,
                                        child: Text(e.cName ?? ''),
                                      );
                                    }).toList(),
                                    onChanged: (TeacherClassItem? value) {
                                      setState(() {
                                        _selectedClass = value;
                                        _selectedStudent = null;
                                      });
                                      if (value != null) {
                                        ctrl.getListOfStudents(
                                          classId: value.cid ?? '',
                                          roleType: RoleType.teacher,
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          // Selector de alumno
                          if (_notifyTo == 'student')
                            Consumer<StudentParentTeacherController>(
                              builder: (context, ctrl, child) {
                                return Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: AppColors.secondary.withValues(alpha: 0.06)),
                                      child: DropdownButton<TeacherClassItem>(
                                        underline: const SizedBox.shrink(),
                                        isExpanded: true,
                                        hint: const Text('Selecciona una clase'),
                                        value: _selectedClass,
                                        items: ctrl.listOfClassAssignToTeacher.map((e) {
                                          return DropdownMenuItem<TeacherClassItem>(
                                            value: e,
                                            child: Text(e.cName ?? ''),
                                          );
                                        }).toList(),
                                        onChanged: (TeacherClassItem? value) {
                                          setState(() {
                                            _selectedClass = value;
                                            _selectedStudent = null;
                                          });
                                          if (value != null) {
                                            ctrl.getListOfStudents(
                                              classId: value.cid ?? '',
                                              roleType: RoleType.teacher,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (_selectedClass != null)
                                      Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: AppColors.secondary.withValues(alpha: 0.06)),
                                        child: DropdownButton<StudentItem>(
                                          underline: const SizedBox.shrink(),
                                          isExpanded: true,
                                          hint: const Text('Selecciona un alumno'),
                                          value: _selectedStudent,
                                          items: ctrl.listOfStudents.map((e) {
                                            return DropdownMenuItem<StudentItem>(
                                              value: e,
                                              child: Text('${e.sLname ?? ''}, ${e.sFname ?? ''}'),
                                            );
                                          }).toList(),
                                          onChanged: (StudentItem? value) {
                                            setState(() { _selectedStudent = value; });
                                          },
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          const SizedBox(height: 20),

                          //add-edit event button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Botón Borrar — solo en modo edición
                              if (arguments?['reason'] == 'edit-event' && eventListItemDetail?.id != null)
                                Consumer<StudentParentTeacherController>(
                                  builder: (context, studentParentTeacherController, child) {
                                    return Container(
                                      height: 60,
                                      padding: const EdgeInsets.all(5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Eliminar evento"),
                                              content: const Text("¿Estás seguro de que quieres eliminar este evento?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text("Cancelar"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    studentParentTeacherController.deleteEvent(
                                                      eventId: eventListItemDetail!.id ?? "",
                                                    );
                                                    Get.back();
                                                  },
                                                  child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Text("Borrar"),
                                      ),
                                    );
                                  },
                                ),
                              const SizedBox(width: 10),
                              Container(
                              height: 60,
                              width: MediaQuery.sizeOf(context).width * 0.30,
                              padding: const EdgeInsets.all(5),
                              child: Consumer<StudentParentTeacherController>(
                                builder: (context,
                                    studentParentTeacherController, child) {
                                  return ElevatedButton(
                                      onPressed: () async {
                                        if (_eventKey.currentState
                                                ?.validate() ??
                                            false) {
                                          if (studentParentTeacherController
                                                      .eventStartDate !=
                                                  null &&
                                              studentParentTeacherController
                                                      .eventEndDate !=
                                                  null) {
                                            await studentParentTeacherController.addEditEvent(
                                                title: titleController?.text ?? "",
                                                description: descriptionController?.text ?? "",
                                                eventStartDate: DateFormat("yyyy-MM-dd").format(studentParentTeacherController.eventStartDate!),
                                                eventEndDate: DateFormat("yyyy-MM-dd").format(studentParentTeacherController.eventEndDate!),
                                                eventStartTime: studentParentTeacherController.startTime == null
                                                    ? ""
                                                    : "${studentParentTeacherController.startTime?.hour ?? ""}:${studentParentTeacherController.startTime?.minute ?? ""}",
                                                eventEndTime: studentParentTeacherController.endTime == null
                                                    ? ""
                                                    : "${studentParentTeacherController.endTime?.hour ?? ""}:${studentParentTeacherController.endTime?.minute ?? ""}",
                                                eventType: studentParentTeacherController.selectedEventType.id,
                                                eventColor: "#007bff",
                                                eventId: eventListItemDetail?.id,
                                                notifyTo: _notifyTo,
                                                notifyClass: _selectedClass?.cid ?? "",
                                                notifyStudent: _selectedStudent?.wpUsrId ?? "",
                                            );
                                          } else {
                                            AppConstants.showCustomToast(
                                                status: false,
                                                message: studentParentTeacherController
                                                            .eventStartDate ==
                                                        null
                                                    ? "Fecha de inicio"
                                                    : "Fecha de finalización");
                                          }
                                        }
                                      },
                                      child: Text(
                                          arguments?['reason'] == "add-event"
                                              ? "Agregar"
                                              : "Editar"));
                                },
                              ),
                            ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
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

  @override
  void dispose() {
    if (!mounted) {
      titleController?.dispose();
      descriptionController?.dispose();
    }
    super.dispose();
  }


  //get time in 00:00 format

  String getTimeInFormat(TimeOfDay startTime) {

    int hour = startTime.hour;
    int minutes = startTime.minute;

    String hourInString = hour < 10 ? "0$hour" : "$hour";
    String minuteInString = minutes < 10 ? "0$minutes" : "$minutes";

    return "$hourInString:$minuteInString";

  }
}
