import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────
// MODELOS
// ─────────────────────────────────────────────

class TeacherLocatorItem {
  final String tid;
  final String wpUsrId;
  final String firstName;
  final String lastName;
  final String currentClass;
  final String currentSubject;
  final String startTime;
  final String endTime;
  final String teacherImage;

  TeacherLocatorItem({
    required this.tid,
    required this.wpUsrId,
    required this.firstName,
    required this.lastName,
    required this.currentClass,
    required this.currentSubject,
    required this.startTime,
    required this.endTime,
    required this.teacherImage,
  });

  factory TeacherLocatorItem.fromJson(Map<String, dynamic> json) {
    return TeacherLocatorItem(
      tid: json['tid']?.toString() ?? '',
      wpUsrId: json['wp_usr_id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      currentClass: json['current_class'] ?? '',
      currentSubject: json['current_subject'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      teacherImage: json['teacher_image'] ?? '',
    );
  }
}

class TeacherScheduleSlot {
  final String hora;
  final String lunes;
  final String martes;
  final String miercoles;
  final String jueves;
  final String viernes;

  TeacherScheduleSlot({
    required this.hora,
    required this.lunes,
    required this.martes,
    required this.miercoles,
    required this.jueves,
    required this.viernes,
  });

  factory TeacherScheduleSlot.fromJson(Map<String, dynamic> json) {
    return TeacherScheduleSlot(
      hora:      json['hora']      ?? '',
      lunes:     json['lunes']     ?? '',
      martes:    json['martes']    ?? '',
      miercoles: json['miercoles'] ?? '',
      jueves:    json['jueves']    ?? '',
      viernes:   json['viernes']   ?? '',
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA PRINCIPAL
// ─────────────────────────────────────────────

class TeacherLocatorScreen extends StatefulWidget {
  const TeacherLocatorScreen({super.key});

  @override
  State<TeacherLocatorScreen> createState() => _TeacherLocatorScreenState();
}

class _TeacherLocatorScreenState extends State<TeacherLocatorScreen> {
  bool _isLoading = false;
  List<TeacherLocatorItem> _teachers = [];
  String _currentTime = '';
  String _currentDay = '';
  String _token = '';
  String _cookie = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _token = AppSharedPreferences.getBasicAthToken() ?? '';
      _cookie = Provider.of<StudentParentTeacherController>(context, listen: false).userdata?.cookies ?? '';
      _loadTeachers();
    });
  }

  Future<void> _loadTeachers() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiClass().teacherLocator(
        token: _token,
        cookie: _cookie,
      );
      if (response != null && response['status'] == true) {
        final List raw = response['teacherlist'] ?? [];
        setState(() {
          _teachers = raw
              .map((e) => TeacherLocatorItem.fromJson(e as Map<String, dynamic>))
              .toList();
          _currentTime = response['current_time'] ?? '';
          _currentDay = response['current_day'] ?? '';
        });
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  String _dayLabel(String day) {
    const map = {
      'lunes': 'Lunes',
      'martes': 'Martes',
      'miercoles': 'Miércoles',
      'jueves': 'Jueves',
      'viernes': 'Viernes',
    };
    return map[day] ?? day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: Text(
          'Localizador de profesores',
          style: AppTextStyle.getOutfit500(textSize: 20, textColor: AppColors.white),
        ),
        onLeadingIconClicked: () => Get.back(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: AppColors.primary.withValues(alpha: 0.08),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Ahora: $_currentTime  ·  ${_dayLabel(_currentDay)}',
                      style: AppTextStyle.getOutfit500(
                          textSize: 14, textColor: AppColors.primary),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _loadTeachers,
                      child: const Icon(Icons.refresh, color: AppColors.primary, size: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _teachers.isEmpty && !_isLoading
                    ? Center(
                        child: Text(
                          'No se encontraron datos',
                          style: AppTextStyle.getOutfit400(
                              textSize: 16, textColor: AppColors.secondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _teachers.length,
                        itemBuilder: (context, i) {
                          final t = _teachers[i];
                          final bool inClass = t.currentSubject.isNotEmpty;
                          return GestureDetector(
                            onTap: () => showTeacherSchedule(context, t, _token, _cookie),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: inClass
                                    ? AppColors.primary.withValues(alpha: 0.07)
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: inClass
                                      ? AppColors.primary.withValues(alpha: 0.3)
                                      : AppColors.secondary.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundImage: NetworkImage(t.teacherImage),
                                    backgroundColor: AppColors.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${t.firstName} ${t.lastName}',
                                          style: AppTextStyle.getOutfit600(
                                              textSize: 15, textColor: AppColors.secondary),
                                        ),
                                        const SizedBox(height: 4),
                                        if (inClass) ...[
                                          Text(
                                            t.currentSubject,
                                            style: AppTextStyle.getOutfit500(
                                                textSize: 13, textColor: AppColors.primary),
                                          ),
                                          Text(
                                            '${t.currentClass}  ·  ${t.startTime} - ${t.endTime}',
                                            style: AppTextStyle.getOutfit400(
                                                textSize: 12,
                                                textColor: AppColors.secondary
                                                    .withValues(alpha: 0.6)),
                                          ),
                                        ] else
                                          Text(
                                            'Sin clase ahora',
                                            style: AppTextStyle.getOutfit400(
                                                textSize: 13,
                                                textColor: AppColors.secondary
                                                    .withValues(alpha: 0.45)),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (inClass)
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          if (_isLoading) const LoadingLayout(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FUNCIÓN GLOBAL PARA ABRIR EL BOTTOM SHEET
// ─────────────────────────────────────────────

void showTeacherSchedule(BuildContext context, TeacherLocatorItem teacher, String token, String cookie) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => TeacherScheduleSheet(
      teacher: teacher,
      token: token,
      cookie: cookie,
    ),
  );
}

// ─────────────────────────────────────────────
// BOTTOM SHEET: HORARIO COMPLETO
// ─────────────────────────────────────────────

class TeacherScheduleSheet extends StatefulWidget {
  final TeacherLocatorItem teacher;
  final String token;
  final String cookie;

  const TeacherScheduleSheet({
    super.key,
    required this.teacher,
    required this.token,
    required this.cookie,
  });

  @override
  State<TeacherScheduleSheet> createState() => _TeacherScheduleSheetState();
}

class _TeacherScheduleSheetState extends State<TeacherScheduleSheet> {
  bool _isLoading = false;
  List<TeacherScheduleSlot> _slots = [];

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiClass().teacherScheduleByUser(
        token: widget.token,
        cookie: widget.cookie,
        wpUsrId: widget.teacher.wpUsrId,
      );
      if (response != null && response['status'] == true) {
        final List raw = response['schedule'] ?? [];
        setState(() {
          _slots = raw
              .map((e) => TeacherScheduleSlot.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const days = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi'];
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(widget.teacher.teacherImage),
                    backgroundColor: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${widget.teacher.firstName} ${widget.teacher.lastName}',
                      style: AppTextStyle.getOutfit600(
                          textSize: 17, textColor: AppColors.secondary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text('Hora',
                        style: AppTextStyle.getOutfit600(
                            textSize: 12, textColor: AppColors.secondary)),
                  ),
                  ...days.map((d) => Expanded(
                        child: Center(
                          child: Text(d,
                              style: AppTextStyle.getOutfit600(
                                  textSize: 12, textColor: AppColors.primary)),
                        ),
                      )),
                ],
              ),
            ),
            const Divider(height: 1),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _slots.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final slot = _slots[i];
                    final values = [
                      slot.lunes,
                      slot.martes,
                      slot.miercoles,
                      slot.jueves,
                      slot.viernes,
                    ];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              slot.hora,
                              style: AppTextStyle.getOutfit400(
                                  textSize: 11, textColor: AppColors.secondary),
                            ),
                          ),
                          ...values.map((v) {
                            final parts = v.split('|');
                            final subject = parts[0].trim();
                            final clase = parts.length > 1 ? parts[1].trim() : '';
                            final isEmpty = subject.isEmpty;
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: isEmpty
                                      ? Colors.transparent
                                      : AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: isEmpty
                                    ? const SizedBox.shrink()
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            subject,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.getOutfit500(
                                                textSize: 9,
                                                textColor: AppColors.secondary),
                                          ),
                                          if (clase.isNotEmpty)
                                            Text(
                                              clase,
                                              textAlign: TextAlign.center,
                                              style: AppTextStyle.getOutfit400(
                                                  textSize: 8,
                                                  textColor: AppColors.primary),
                                            ),
                                        ],
                                      ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
