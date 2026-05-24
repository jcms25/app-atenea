import 'package:colegia_atenea/models/student_list_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Pantalla de selección múltiple de alumnos para registrar
/// una incidencia actitudinal a varios a la vez.
class TeacherSelectStudentsScreen extends StatefulWidget {
  final List<StudentItem> students;
  final String classId;
  final String className;

  const TeacherSelectStudentsScreen({
    super.key,
    required this.students,
    required this.classId,
    required this.className,
  });

  @override
  State<TeacherSelectStudentsScreen> createState() =>
      _TeacherSelectStudentsScreenState();
}

class _TeacherSelectStudentsScreenState
    extends State<TeacherSelectStudentsScreen> {
  // wpUsrId de los alumnos marcados
  final Set<String> _selectedIds = {};

  bool get _allSelected =>
      widget.students.isNotEmpty &&
      _selectedIds.length == widget.students.length;

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(widget.students.map((s) => s.wpUsrId ?? ''));
        _selectedIds.remove('');
      }
    });
  }

  void _toggleOne(String wpUsrId) {
    setState(() {
      if (_selectedIds.contains(wpUsrId)) {
        _selectedIds.remove(wpUsrId);
      } else {
        _selectedIds.add(wpUsrId);
      }
    });
  }

  void _accept() {
    if (_selectedIds.isEmpty) {
      AppConstants.showCustomToast(
          status: false, message: 'Selecciona al menos un alumno');
      return;
    }
    // Devolvemos los alumnos seleccionados a la pantalla anterior
    final selected = widget.students
        .where((s) => _selectedIds.contains(s.wpUsrId ?? ''))
        .toList();
    Get.back(result: selected);
  }

  /// Formatea el nombre como "Apellidos, Nombre".
  String _formatStudentName(StudentItem s) {
    final apellidos = (s.sLname ?? '').trim();
    final nombre = (s.sFname ?? '').trim();
    if (apellidos.isEmpty) return nombre;
    if (nombre.isEmpty) return apellidos;
    return '$apellidos, $nombre';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        onLeadingIconClicked: () => Get.back(),
        title: Text(
          'Seleccionar alumnos',
          style: AppTextStyle.getOutfit600(
              textSize: 20, textColor: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          // Cabecera: clase + seleccionar todos
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: AppColors.primary,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.className,
                  style: AppTextStyle.getOutfit600(
                      textSize: 18, textColor: AppColors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_selectedIds.length} seleccionado(s)',
                  style: AppTextStyle.getOutfit400(
                      textSize: 14,
                      textColor: AppColors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
          // Seleccionar todos
          InkWell(
            onTap: _toggleAll,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Checkbox(
                    value: _allSelected,
                    activeColor: AppColors.primary,
                    onChanged: (_) => _toggleAll(),
                  ),
                  Text(
                    'Seleccionar todos',
                    style: AppTextStyle.getOutfit600(
                        textSize: 15, textColor: AppColors.secondary),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Lista de alumnos
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView.separated(
                itemCount: widget.students.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final s = widget.students[index];
                  final id = s.wpUsrId ?? '';
                  final selected = _selectedIds.contains(id);
                  return InkWell(
                    onTap: () => _toggleOne(id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selected,
                            activeColor: AppColors.primary,
                            onChanged: (_) => _toggleOne(id),
                          ),
                          Expanded(
                            child: Text(
                              _formatStudentName(s),
                              style: AppTextStyle.getOutfit400(
                                  textSize: 16,
                                  textColor: AppColors.secondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Botón Aceptar
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: CustomButtonWidget(
                buttonTitle: 'Aceptar',
                onPressed: _accept,
              ),
            ),
          ),
        ],
      ),
    );
  }
}