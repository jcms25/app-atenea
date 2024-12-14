import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'app_colors.dart';
import 'app_images.dart';

class AppConstants {
  static const List<String> daysInSpanish = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi'];

  //role drop down
  static const List<String> roleDropDown = [
    "Seleccionar perfil",
    "Alumno",
    "Padre",
    "Profesor",
    "Asistente"
  ];

  //bottom navigation bar

  //parent
  static const List<OptionModel> bottomNavigationBarParent = [
    OptionModel(
        optionId: 0, optionName: "dashboard", optionIcon: AppImages.dashboard),
    OptionModel(
        optionId: 1, optionName: "circular", optionIcon: AppImages.circular),
    OptionModel(
        optionId: 2,
        optionName: "communication",
        optionIcon: AppImages.message),
    OptionModel(
        optionId: 3, optionName: "child-info", optionIcon: AppImages.people),
    OptionModel(
        optionId: 4, optionName: "class", optionIcon: AppImages.calender),
    OptionModel(optionId: 5, optionName: "events", optionIcon: AppImages.event),
  ];

  //student
  static const List<OptionModel> bottomNavigationBarStudent = [
    OptionModel(
        optionId: 0, optionName: "dashboard", optionIcon: AppImages.dashboard),
    OptionModel(
        optionId: 1,
        optionName: "communication",
        optionIcon: AppImages.message),
    OptionModel(
        optionId: 2, optionName: "child-info", optionIcon: AppImages.people),
    OptionModel(
        optionId: 3, optionName: "class", optionIcon: AppImages.calender),
    OptionModel(optionId: 4, optionName: "events", optionIcon: AppImages.event),
  ];

  //assistant
  static List<OptionModel> bottomNavigationBarAssistant = [
    const OptionModel(
        optionId: 0, optionName: 'Dashboard', optionIcon: AppImages.dashboard),
    const OptionModel(
        optionId: 1, optionName: 'classes', optionIcon: AppImages.calender),
    const OptionModel(
        optionId: 2,
        optionName: 'communication',
        optionIcon: AppImages.message),
    const OptionModel(
        optionId: 3,
        optionName: 'send report communication',
        optionIcon: AppImages.dashboard)
  ];

  //teacher
  static const List<OptionModel> bottomNavigationBarTeacher = [
    OptionModel(
        optionId: 0, optionName: 'Dashboard', optionIcon: AppImages.dashboard),
    OptionModel(
        optionId: 1,
        optionName: 'Communications',
        optionIcon: AppImages.message),
    OptionModel(
        optionId: 2, optionName: 'Clases ', optionIcon: AppImages.calender),
    OptionModel(
        optionId: 3,
        optionName: 'Gestión docente ',
        optionIcon: AppImages.teachingManagement),
    OptionModel(optionId: 4, optionName: "events", optionIcon: AppImages.event),
  ];

  //Drawer List

  //parent
  static final List<Map<String, dynamic>> drawerListParent = [
    {
      "name": "drawerOption1".tr,
      "icon": AppImages.dashboard,
    },
    {
      "name": "drawerOption5".tr,
      "icon": AppImages.circular,
    },
    {
      "name": "drawerOption6".tr,
      "icon": AppImages.message,
    },
    {
      "name": "drawerOption7".tr,
      "icon": AppImages.people,
    },
    {
      "name": "drawerOption4".tr,
      "icon": AppImages.event,
    },
    {"name": 'drawerOption10'.tr, "icon": AppImages.dinningIcon}
  ];

  //student
  static final List<Map<String, String>> drawerListStudent = [
    {
      "name": "drawerOption1".tr,
      "icon": AppImages.dashboard,
    },
    {
      "name": "drawerOption6".tr,
      "icon": AppImages.message,
    },
    {
      "name": "drawerOption2".tr,
      "icon": AppImages.people,
    },
    {
      "name": "drawerOption3".tr,
      "icon": AppImages.calender,
    },
    {
      "name": "drawerOption4".tr,
      "icon": AppImages.event,
    },
    {"name": 'drawerOption10'.tr, "icon": AppImages.dinningIcon}
  ];

  //teacher
  static final List<Map<String, String>> drawerListTeacher = [
    {
      "name": "drawerOption1".tr,
      "icon": AppImages.dashboard,
    },
    {
      "name": "drawerOption6".tr,
      "icon": AppImages.message,
    },
    {"name": 'drawerOption8'.tr, "icon": AppImages.calender},
    {
      "name": 'drawerOption9'.tr,
      "icon": AppImages.teachingManagement,
    },
    {
      "name": 'drawerOption4'.tr,
      "icon": AppImages.event,
    },
    {"name": 'drawerOption10'.tr, "icon": AppImages.dinningIcon}
  ];

  //sub menu list
  static List<Map<String, String>> subMenuList = [
    {"name": "Envíos del Profesor"},
    {
      "name": "subMenuDrawer1".tr,
    },
    {
      "name": "subMenuDrawer2".tr,
    },
    {
      "name": "subMenuDrawer3".tr,
    },
    {
      "name": "subMenuDrawer4".tr,
    },
    {
      "name": "subMenuDrawer5".tr,
    },
    {
      "name": "subMenuDrawer6".tr,
    },
    {
      "name": "subMenuDrawer7".tr,
    },
    {
      "name": "subMenuDrawer9".tr,
    },
  ];

  //teacher sub menu list 1
  static List<Map<String, String>> classSubMenuListTeacher = [
    {"name": "drawerOption7".tr},
    {"name": "drawerOption2".tr},
    {"name": 'subMenuDrawer2'.tr},
    {"name": 'subMenuDrawer4'.tr},
    {"name": 'subMenuDrawer1'.tr}
  ];

  //teacher sub menu list 2
  static List<Map<String, String>> teachingSubMenuListTeacher = [
    {"name": 'subMenuDrawer12'.tr},
    {"name": 'subMenuDrawer5'.tr},
    {"name": 'subMenuDrawer6'.tr},
    {"name": 'subMenuDrawer13'.tr}
  ];

  //teacher sub menu list 3
  static List<Map<String, String>> dinningSubMenuListTeacher = [
    {"name": 'subMenuDrawer11'.tr},
    {"name": 'subMenuDrawer10'.tr}
  ];

  //event type
  static List<EventTypeModel> eventTypeList = [
    EventTypeModel(id: "0", eventType: "Externo (mostrar a todos)"),
    EventTypeModel(id: "1", eventType: "Internal (show to teachers only)")
  ];

  //event color model
  static List<EventColorModel> eventColorModel = [
    EventColorModel(id: "#007bff", color: "Por defecto"),
    EventColorModel(id: "#28a745", color: "Sesión de evaluación"),
    EventColorModel(id: "#ffc107", color: "Celebración Pedagógica"),
    EventColorModel(id: "#dc3545", color: "Festividad"),
    EventColorModel(id: "#17a2b8", color: "Vacaciones"),
  ];

  //show custom toast message
  static void showCustomToast({required bool status, required String message}) {
    Fluttertoast.showToast(
        backgroundColor: status ? AppColors.green : AppColors.red,
        textColor: AppColors.white,
        msg: message);
  }

  //Message Type
  static String messageType1 = "Recibidas";
  static String messageType2 = "Enviadas";

  //Keys
  static final GlobalKey<ScaffoldState> _mainScreenKey =
      GlobalKey<ScaffoldState>();

  static GlobalKey<ScaffoldState> get mainScreenKey => _mainScreenKey;

  static final GlobalKey<ScaffoldState> _assistantKey =
      GlobalKey<ScaffoldState>();

  static GlobalKey<ScaffoldState> get assistantKey => _assistantKey;

  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  static GlobalKey<FormState> get loginFormKey => _loginFormKey;
}

class OptionModel {
  final int optionId;
  final String optionName;
  final String optionIcon;

  const OptionModel(
      {required this.optionId,
      required this.optionName,
      required this.optionIcon});
}

class EventTypeModel {
  final String id;
  final String eventType;

  const EventTypeModel({required this.id, required this.eventType});
}

class EventColorModel {
  final String id;
  final String color;

  const EventColorModel({required this.id, required this.color});
}
