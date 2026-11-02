import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/dinning_menu_month_response.dart';
import 'package:colegia_atenea/models/dinning_menu_response.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MenuMonthScreen extends StatefulWidget {
  const MenuMonthScreen({super.key});

  @override
  State<MenuMonthScreen> createState() => _MenuMonthScreenState();
}

class _MenuMonthScreenState extends State<MenuMonthScreen> {
  StudentParentTeacherController? controller;
  late int _month;
  late int _year;
  bool _started = false;
  bool _scrolledToToday = false;
  final GlobalKey _todayKey = GlobalKey();

  static const List<String> _monthNames = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  static const List<String> _dayNames = [
    'LUN',
    'MAR',
    'MIÉ',
    'JUE',
    'VIE',
    'SÁB',
    'DOM'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = now.month;
    _year = now.year;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      controller?.setDinningMonthData(dinningMonthData: null);
      _started = true;
      controller?.getDinningMenuMonth(month: _month, year: _year);
    });
  }

  DateTime? _parseMonth(String? value) {
    if (value == null || value.length < 7) return null;
    final y = int.tryParse(value.substring(0, 4));
    final m = int.tryParse(value.substring(5, 7));
    if (y == null || m == null) return null;
    return DateTime(y, m);
  }

  bool _canGoPrev(DinningMenuMonthData? data) {
    final first = _parseMonth(data?.firstMonth);
    return first != null && DateTime(_year, _month).isAfter(first);
  }

  bool _canGoNext(DinningMenuMonthData? data) {
    final last = _parseMonth(data?.lastMonth);
    return last != null && DateTime(_year, _month).isBefore(last);
  }

  void _changeMonth(int delta) {
    final target = DateTime(_year, _month + delta);
    setState(() {
      _month = target.month;
      _year = target.year;
      _scrolledToToday = false;
    });
    controller?.getDinningMenuMonth(month: _month, year: _year);
  }

  bool _isHoliday(DinningMenuData d) {
    final p1 = (d.menuP1 ?? '').trim();
    final p2 = (d.menuP2 ?? '').trim().toLowerCase();
    return p1.isEmpty && (p2.contains('festivo') || p2.contains('no lectivo'));
  }

  void _downloadPdf() {
    final data = controller?.dinningMonthData;
    final url = (data != null && data.month == _month && data.year == _year)
        ? (data.pdfUrl ?? '')
        : '';
    if (url.isEmpty) {
      AppConstants.showCustomToast(
          status: false, message: 'PDF no disponible para este mes');
      return;
    }
    controller?.openUrl(url: url);
  }

  void _showAllergens() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Alérgenos',
                  style: AppTextStyle.getOutfit600(
                      textSize: 18, textColor: AppColors.black),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Image.asset(AppImages.menuImage),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (ctx, res) {
        controller?.setDinningMonthData(dinningMonthData: null);
        controller?.setIsLoading(isLoading: false);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            controller?.setDinningMonthData(dinningMonthData: null);
            controller?.setIsLoading(isLoading: false);
            Get.back();
          },
          title: Text(
            'Menú mensual',
            style: AppTextStyle.getOutfit600(
                textSize: 20, textColor: AppColors.white),
          ),
          actionIcons: [
            IconButton(
              tooltip: 'Alérgenos',
              icon: const Icon(Icons.info_outline, color: AppColors.white),
              onPressed: _showAllergens,
            ),
            IconButton(
              tooltip: 'Descargar PDF',
              icon: const Icon(Icons.download, color: AppColors.white),
              onPressed: _downloadPdf,
            ),
          ],
        ),
        body: Stack(
          children: [
            Consumer<StudentParentTeacherController>(
              builder: (context, c, child) {
                final raw = c.dinningMonthData;
                return Column(
                  children: [
                    _monthSelector(raw),
                    Expanded(child: _buildBody(c, raw)),
                  ],
                );
              },
            ),
            Consumer<StudentParentTeacherController>(
              builder: (context, c, child) {
                return Visibility(
                    visible: c.isLoading, child: LoadingLayout());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthSelector(DinningMenuMonthData? data) {
    final canPrev = _canGoPrev(data);
    final canNext = _canGoNext(data);
    return Container(
      color: AppColors.color10,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: canPrev ? () => _changeMonth(-1) : null,
            icon: Icon(Icons.chevron_left,
                size: 30,
                color: canPrev ? AppColors.primary : AppColors.searchIcon),
          ),
          Text(
            '${_monthNames[_month - 1]} $_year',
            style: AppTextStyle.getOutfit600(
                textSize: 18, textColor: AppColors.black),
          ),
          IconButton(
            onPressed: canNext ? () => _changeMonth(1) : null,
            icon: Icon(Icons.chevron_right,
                size: 30,
                color: canNext ? AppColors.primary : AppColors.searchIcon),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
      StudentParentTeacherController c, DinningMenuMonthData? raw) {
    if (raw == null || raw.month != _month || raw.year != _year) {
      if (c.isLoading || !_started) return const SizedBox.shrink();
      return _message('No se pudo cargar el menú de este mes');
    }
    if (raw.days.isEmpty) {
      return _message('Menú de este mes aún no ingresado');
    }

    final now = DateTime.now();
    if (!_scrolledToToday) {
      _scrolledToToday = true;
      if (now.month == _month && now.year == _year) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = _todayKey.currentContext;
          if (ctx != null) {
            Scrollable.ensureVisible(ctx,
                duration: const Duration(milliseconds: 300), alignment: 0.1);
          }
        });
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildWeeks(raw.days),
      ),
    );
  }

  Widget _message(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyle.getOutfit500(
            textSize: 16, textColor: AppColors.secondary),
      ),
    );
  }

  List<Widget> _buildWeeks(List<DinningMenuData> days) {
    final List<Widget> widgets = [];
    DateTime? currentWeekStart;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isCurrentMonth = now.month == _month && now.year == _year;

    for (final d in days) {
      final date = DateTime.tryParse(d.menuDate ?? '');
      if (date == null) continue;
      final weekStart =
          DateTime(date.year, date.month, date.day - (date.weekday - 1));
      if (currentWeekStart == null || weekStart != currentWeekStart) {
        currentWeekStart = weekStart;
        widgets.add(_weekHeader(weekStart));
      }
      final dayDate = DateTime(date.year, date.month, date.day);
      final isToday = dayDate == today;
      final isPast = isCurrentMonth && dayDate.isBefore(today);
      widgets.add(_dayCard(date, d, isToday, isPast));
    }
    return widgets;
  }

  Widget _weekHeader(DateTime start) {
    final end = DateTime(start.year, start.month, start.day + 4);
    final text = start.month == end.month
        ? 'Semana del ${start.day} al ${end.day}'
        : 'Semana del ${DateFormat('dd/MM').format(start)} al ${DateFormat('dd/MM').format(end)}';
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Text(
        text,
        style: AppTextStyle.getOutfit500(
            textSize: 13, textColor: AppColors.secondary),
      ),
    );
  }

  Widget _dayCard(
      DateTime date, DinningMenuData d, bool isToday, bool isPast) {
    final holiday = _isHoliday(d);
    final lines = [d.menuP1, d.menuP2, d.menuP3, d.menuP4]
        .map((e) => (e ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final dayBox = Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isToday ? AppColors.primary : AppColors.color10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _dayNames[date.weekday - 1],
            style: AppTextStyle.getOutfit400(
                textSize: 11,
                textColor: isToday ? AppColors.orange : AppColors.secondary),
          ),
          Text(
            '${date.day}',
            style: AppTextStyle.getOutfit600(
                textSize: 18,
                textColor: isToday ? AppColors.white : AppColors.black),
          ),
        ],
      ),
    );

    Widget content;
    if (holiday) {
      content = Text(
        lines.join(' '),
        style: AppTextStyle.getOutfit500(
            textSize: 14, textColor: AppColors.secondary),
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < lines.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: (i == 0 && isToday)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            lines[i],
                            style: AppTextStyle.getOutfit400(
                                textSize: 14, textColor: AppColors.black),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Hoy',
                            style: AppTextStyle.getOutfit500(
                                textSize: 11, textColor: AppColors.orange),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      lines[i],
                      style: AppTextStyle.getOutfit400(
                          textSize: 14, textColor: AppColors.black),
                    ),
            ),
        ],
      );
    }

    final card = Container(
      key: isToday ? _todayKey : null,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: holiday ? AppColors.color10 : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday ? AppColors.primary : AppColors.searchIcon,
          width: isToday ? 2 : 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            holiday ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          dayBox,
          const SizedBox(width: 10),
          Expanded(child: content),
        ],
      ),
    );

    return isPast ? Opacity(opacity: 0.55, child: card) : card;
  }
}
