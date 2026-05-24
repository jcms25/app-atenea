import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/classroom_subject_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Formulario para registrar una nueva incidencia actitudinal.
class TeacherAddClassroomEventScreen extends StatefulWidget {
  // Lista de wp_usr_id de los alumnos (uno o varios)
  final List<String> studentIds;
  // Nombre del alumno (solo si es uno); para varios va vacío
  final String studentName;
  // Nombres de todos los alumnos seleccionados (para el diálogo de comprobación)
  final List<String> studentNames;
  final String classId;
  final String className;

  const TeacherAddClassroomEventScreen({
    super.key,
    required this.studentIds,
    this.studentName = '',
    this.studentNames = const [],
    required this.classId,
    required this.className,
  });

  @override
  State<TeacherAddClassroomEventScreen> createState() =>
      _TeacherAddClassroomEventScreenState();
}

class _TeacherAddClassroomEventScreenState
    extends State<TeacherAddClassroomEventScreen> {
  StudentParentTeacherController? controller;

  DateTime selectedDateTime = DateTime.now();
  int? selectedTagId;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      controller =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      // Cargar etiquetas
      await controller?.getClassroomTags();
      // Cascada inicial con la fecha/hora actual
      await _refreshSubjectCascade();
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  //Formato que espera el backend: YYYY-MM-DDTHH:MM
  String get _datetimeForApi =>
      DateFormat("yyyy-MM-dd'T'HH:mm").format(selectedDateTime);

  // Formato visible para el usuario
  String get _datetimeForDisplay =>
      DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime);

  Future<void> _refreshSubjectCascade() async {
    // La cascada usa el primer alumno (todos comparten clase y horario)
    final firstStudentId =
        widget.studentIds.isNotEmpty ? widget.studentIds.first : '';
    await controller?.getSubjectByDatetime(
      studentId: firstStudentId,
      classId: widget.classId,
      datetime: _datetimeForApi,
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      locale: const Locale('es', 'ES'),
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('es', 'ES'),
          child: child,
        );
      },
    );
    if (time == null) return;
    setState(() {
      selectedDateTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
    // Al cambiar fecha/hora, recalcular la asignatura sugerida
    await _refreshSubjectCascade();
  }

  Future<void> _save() async {
    if (controller?.selectedClassroomSubject == null) {
      AppConstants.showCustomToast(
          status: false, message: 'Selecciona una asignatura');
      return;
    }
    if (selectedTagId == null) {
      AppConstants.showCustomToast(
          status: false, message: 'Selecciona una etiqueta');
      return;
    }
    final ok = await controller?.saveClassroomEvent(
          studentIds: widget.studentIds,
          classId: widget.classId,
          subjectId: controller?.selectedClassroomSubject?.id ?? 0,
          tagId: selectedTagId ?? 0,
          datetime: _datetimeForApi,
          comment: commentController.text.trim(),
        ) ??
        false;
    if (!mounted) return;
    if (ok) {
      AppConstants.showCustomToast(
          status: true, message: 'Incidencia registrada');
      // Si es un solo alumno, refrescamos su histórico
      if (widget.studentIds.length == 1) {
        await controller?.getClassroomEvents(
            studentId: widget.studentIds.first, showLoader: false);
      }
      if (mounted) Get.back();
    } else {
      AppConstants.showCustomToast(
          status: false, message: 'No se pudo guardar la incidencia');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        onLeadingIconClicked: () => Get.back(),
        title: Text(
          'Nueva incidencia',
          style: AppTextStyle.getOutfit600(
              textSize: 20, textColor: AppColors.white),
        ),
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info alumno(s) / clase
                  widget.studentIds.length == 1
                      ? _infoRow('Alumno', widget.studentName)
                      : _infoRowTappable(
                          'Alumnos',
                          '${widget.studentIds.length} seleccionados',
                          _showStudentsDialog,
                        ),
                  const SizedBox(height: 8),
                  _infoRow('Clase', widget.className),
                  const SizedBox(height: 24),

                  // Fecha y hora
                  _label('Fecha y hora'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDateTime,
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary.withValues(alpha: 0.05),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _datetimeForDisplay,
                            style: AppTextStyle.getOutfit500(
                                textSize: 16,
                                textColor: AppColors.secondary),
                          ),
                          Icon(Icons.calendar_today,
                              color: AppColors.primary, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Asignatura (cascada)
                  _label('Asignatura'),
                  const SizedBox(height: 8),
                  Consumer<StudentParentTeacherController>(
                    builder: (context, controller, child) {
                      return Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary.withValues(alpha: 0.05),
                        ),
                        child: controller.classroomSubjectOptions.isNotEmpty
                            ? DropdownButton<ClassroomSubject>(
                                underline: const SizedBox.shrink(),
                                isExpanded: true,
                                value: controller.selectedClassroomSubject,
                                hint: Text('Selecciona asignatura',
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 16,
                                        textColor: AppColors.secondary)),
                                items: controller.classroomSubjectOptions
                                    .map((s) {
                                  return DropdownMenuItem<ClassroomSubject>(
                                    value: s,
                                    child: Text(s.name,
                                        style: AppTextStyle.getOutfit400(
                                            textSize: 16,
                                            textColor: AppColors.secondary)),
                                  );
                                }).toList(),
                                onChanged: (s) {
                                  controller.setSelectedClassroomSubject(s);
                                },
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Sin asignaturas disponibles',
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 16,
                                        textColor: AppColors.secondary
                                            .withValues(alpha: 0.5))),
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Etiqueta
                  _label('Etiqueta'),
                  const SizedBox(height: 8),
                  Consumer<StudentParentTeacherController>(
                    builder: (context, controller, child) {
                      final allTags = [
                        ...controller.classroomTagsPositive,
                        ...controller.classroomTagsNegative,
                      ];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary.withValues(alpha: 0.05),
                        ),
                        child: DropdownButton<int>(
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          value: selectedTagId,
                          hint: Text('Selecciona una etiqueta',
                              style: AppTextStyle.getOutfit400(
                                  textSize: 16,
                                  textColor: AppColors.secondary)),
                          items: allTags.map((t) {
                            return DropdownMenuItem<int>(
                              value: t.id,
                              child: Text('${t.emoji}  ${t.label}',
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 15,
                                      textColor: AppColors.secondary)),
                            );
                          }).toList(),
                          onChanged: (id) {
                            setState(() => selectedTagId = id);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Comentario
                  _label('Comentario (opcional)'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary.withValues(alpha: 0.05),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: commentController,
                      maxLines: 4,
                      style: AppTextStyle.getOutfit400(
                          textSize: 16, textColor: AppColors.secondary),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Escribe un comentario...',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón guardar
                  SizedBox(
                    width: double.infinity,
                    child: CustomButtonWidget(
                      buttonTitle: 'Guardar incidencia',
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<StudentParentTeacherController>(
            builder: (context, controller, child) {
              return Visibility(
                visible: controller.isLoading,
                child: LoadingLayout(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: AppTextStyle.getOutfit500(
          textSize: 16, textColor: AppColors.secondary),
    );
  }

Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ',
            style: AppTextStyle.getOutfit400(
                textSize: 16,
                textColor: AppColors.secondary.withValues(alpha: 0.5))),
        Expanded(
          child: Text(value,
              style: AppTextStyle.getOutfit600(
                  textSize: 16, textColor: AppColors.secondary)),
        ),
      ],
    );
  }

  // Fila de info pulsable: el valor se muestra como enlace con un icono.
  Widget _infoRowTappable(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text('$label: ',
              style: AppTextStyle.getOutfit400(
                  textSize: 16,
                  textColor: AppColors.secondary.withValues(alpha: 0.5))),
          Expanded(
            child: Text(value,
                style: AppTextStyle.getOutfit600(
                    textSize: 16, textColor: AppColors.primary)),
          ),
          Icon(Icons.list_alt, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }

  // Diálogo que muestra la lista de nombres de los alumnos seleccionados.
  void _showStudentsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Alumnos seleccionados (${widget.studentNames.length})',
            style: AppTextStyle.getOutfit600(
                textSize: 18, textColor: AppColors.secondary),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.studentNames.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '${index + 1}.  ${widget.studentNames[index]}',
                      style: AppTextStyle.getOutfit400(
                          textSize: 16, textColor: AppColors.secondary),
                    ),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cerrar',
                style: AppTextStyle.getOutfit600(
                    textSize: 15, textColor: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}