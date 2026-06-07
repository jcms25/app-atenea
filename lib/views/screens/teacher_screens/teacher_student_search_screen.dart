import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/class_menu_details_screen/student_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentSearchItem {
  final String sid;
  final String wpUsrId;
  final String sFname;
  final String sLname;
  final String className;
  final String classId;
  final String stuImage;
  final String stuEmail;

  StudentSearchItem({
    required this.sid,
    required this.wpUsrId,
    required this.sFname,
    required this.sLname,
    required this.className,
    required this.classId,
    required this.stuImage,
    required this.stuEmail,
  });

  factory StudentSearchItem.fromJson(Map<String, dynamic> json) {
    return StudentSearchItem(
      sid: json['sid']?.toString() ?? '',
      wpUsrId: json['wp_usr_id']?.toString() ?? '',
      sFname: json['s_fname'] ?? '',
      sLname: json['s_lname'] ?? '',
      className: json['class_name'] ?? '',
      classId: json['class_id']?.toString() ?? '',
      stuImage: json['stu_image'] ?? '',
      stuEmail: json['stu_email'] ?? '',
    );
  }
}

class ClassItem {
  final String cid;
  final String cName;
  ClassItem({required this.cid, required this.cName});
  factory ClassItem.fromJson(Map<String, dynamic> json) {
    return ClassItem(
      cid: json['cid']?.toString() ?? '',
      cName: json['c_name'] ?? '',
    );
  }
}

class TeacherStudentSearchScreen extends StatefulWidget {
  const TeacherStudentSearchScreen({super.key});

  @override
  State<TeacherStudentSearchScreen> createState() => _TeacherStudentSearchScreenState();
}

class _TeacherStudentSearchScreenState extends State<TeacherStudentSearchScreen> {
  bool _byClass = true;
  bool _isLoading = false;

  List<ClassItem> _classes = [];
  ClassItem? _selectedClass;

  List<StudentSearchItem> _allStudents = [];
  List<StudentSearchItem> _filteredStudents = [];
  StudentSearchItem? _selectedStudent;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final token = AppSharedPreferences.getBasicAthToken() ?? '';
      final controller = Provider.of<StudentParentTeacherController>(context, listen: false);
      final cookie = controller.userdata?.cookies ?? '';
      final response = await ApiClass().teacherStudentSearch(
        token: token,
        cookie: cookie,
        search: '',
      );
      if (response != null && response['status'] == true) {
        final List classRaw = response['classlist'] ?? [];
        final List stuRaw = response['studentlist'] ?? [];
        setState(() {
          _classes = classRaw.map((e) => ClassItem.fromJson(e as Map<String, dynamic>)).toList();
          _allStudents = stuRaw.map((e) => StudentSearchItem.fromJson(e as Map<String, dynamic>)).toList();
        });
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  void _onClassSelected(ClassItem? c) {
    setState(() {
      _selectedClass = c;
      _selectedStudent = null;
      _filteredStudents = c != null
          ? (_allStudents.where((s) => s.classId == c.cid).toList()
            ..sort((a, b) {
              int cmp = a.sLname.toLowerCase().compareTo(b.sLname.toLowerCase());
              if (cmp != 0) return cmp;
              return a.sFname.toLowerCase().compareTo(b.sFname.toLowerCase());
            }))
          : [];
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _selectedStudent = null;
      if (query.isEmpty) {
        _filteredStudents = [];
      } else {
        final q = query.toLowerCase();
        _filteredStudents = _allStudents.where((s) {
          return s.sFname.toLowerCase().contains(q) ||
              s.sLname.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: Text(
          'Buscador de alumnos',
          style: AppTextStyle.getOutfit500(textSize: 20, textColor: AppColors.white),
        ),
        onLeadingIconClicked: () => Get.back(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _ModeChip(
                      label: 'Por clase',
                      selected: _byClass,
                      onTap: () => setState(() {
                        _byClass = true;
                        _selectedStudent = null;
                        _filteredStudents = [];
                        _selectedClass = null;
                        _searchController.clear();
                      }),
                    ),
                    const SizedBox(width: 10),
                    _ModeChip(
                      label: 'Manual',
                      selected: !_byClass,
                      onTap: () => setState(() {
                        _byClass = false;
                        _selectedStudent = null;
                        _filteredStudents = [];
                        _selectedClass = null;
                        _searchController.clear();
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (_byClass) ...[
                  _buildDropdown<ClassItem>(
                    hint: 'Selecciona una clase',
                    value: _selectedClass,
                    items: _classes,
                    labelBuilder: (c) => c.cName,
                    onChanged: _onClassSelected,
                  ),
                  const SizedBox(height: 12),
                  if (_filteredStudents.isNotEmpty)
                    _buildDropdown<StudentSearchItem>(
                      hint: 'Selecciona un alumno',
                      value: _selectedStudent,
                      items: _filteredStudents,
                      labelBuilder: (s) => '${s.sLname}, ${s.sFname}',
                      onChanged: (s) => setState(() => _selectedStudent = s),
                    ),
                ] else ...[
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                        hintText: 'Escribe nombre o apellido...',
                        hintStyle: AppTextStyle.getOutfit400(
                            textSize: 15,
                            textColor: AppColors.secondary.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_filteredStudents.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withValues(alpha: 0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredStudents.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final s = _filteredStudents[i];
                          final isSelected = _selectedStudent?.sid == s.sid;
                          return ListTile(
                            selected: isSelected,
                            selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(s.stuImage),
                              backgroundColor: AppColors.primary,
                            ),
                            title: Text(
                              '${s.sLname}, ${s.sFname}',
                              style: AppTextStyle.getOutfit500(
                                  textSize: 15, textColor: AppColors.secondary),
                            ),
                            subtitle: Text(
                              s.className,
                              style: AppTextStyle.getOutfit400(
                                  textSize: 13,
                                  textColor: AppColors.secondary.withValues(alpha: 0.6)),
                            ),
                            onTap: () => setState(() => _selectedStudent = s),
                          );
                        },
                      ),
                    ),
                ],

                const SizedBox(height: 24),

                if (_selectedStudent != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(_selectedStudent!.stuImage),
                          backgroundColor: AppColors.primary,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_selectedStudent!.sFname} ${_selectedStudent!.sLname}',
                                style: AppTextStyle.getOutfit600(
                                    textSize: 16, textColor: AppColors.secondary),
                              ),
                              Text(
                                _selectedStudent!.className,
                                style: AppTextStyle.getOutfit400(
                                    textSize: 13,
                                    textColor: AppColors.secondary.withValues(alpha: 0.6)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => StudentDetails(
                              sid: _selectedStudent!.wpUsrId,
                              pValue: '',
                            ));
                      },
                      icon: const Icon(Icons.person, color: AppColors.white),
                      label: Text(
                        'Ver alumno',
                        style: AppTextStyle.getOutfit600(
                            textSize: 16, textColor: AppColors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_isLoading) const LoadingLayout(),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          hint: Text(hint,
              style: AppTextStyle.getOutfit400(
                  textSize: 15,
                  textColor: AppColors.secondary.withValues(alpha: 0.5))),
          value: value,
          items: items
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      labelBuilder(e),
                      style: AppTextStyle.getOutfit400(
                          textSize: 15, textColor: AppColors.secondary),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyle.getOutfit500(
            textSize: 14,
            textColor: selected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}