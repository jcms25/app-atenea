import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

import 'app_colors.dart';
import 'app_images.dart';

enum MessageSendCategoryForTeacher{student,parent,toAllParent,toAllStudent}

enum TypesOfPaymentMethod{cash,paypal,bizum,servired}

class AppConstants {
  static const ampaProfile = "https://colegioatenea.es/ampa/";


  static const List<String> daysInSpanish = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi'];

// Helper function to format price
  static String formatPrice(double price) {
    double priceFormat = price / 100; // Convert cents to euros
    final formatter = NumberFormat.currency(locale: 'de_DE', symbol: '€');
    return formatter.format(priceFormat); // Example: 2514 -> "25,14 €"
  }

  static String convertToPaypalAmount(String totalPriceInCents) {
    double cents = double.parse(totalPriceInCents);
    return (cents / 100).toStringAsFixed(2); // e.g., "870" → "8.70"
  }

  static const List<MessageSendCategoryForTeacher> listOfCategoryToTeacherSendMessage = [
    MessageSendCategoryForTeacher.student,
    MessageSendCategoryForTeacher.parent,
    MessageSendCategoryForTeacher.toAllStudent,
    MessageSendCategoryForTeacher.toAllParent
  ];


  //role drop down
  static const List<String> roleDropDown = [
    "Seleccionar perfil",
    "Alumno",
    "Padre",
    "Profesor",
    "Asistente"
  ];


  //HTML Escape
  static var unescape = HtmlUnescape();


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
    {"name": 'drawerOption10'.tr,
      "icon": AppImages.dinningIcon,
    },
    {"name": 'drawerOption11'.tr,
      "icon": AppImages.storeIcon,
    }
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
    {"name": 'subMenuDrawer24'.tr}
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

  //store sub menu list : parent
  static List<Map<String,String>> subMenuListStore = [
    {"name" : "subMenuDrawer14".tr,
      "icon": AppImages.billingIcon,
    },
    {"name" : "subMenuDrawer15".tr,
      "icon": AppImages.orderHistory,
    },
    {"name" : "subMenuDrawer16".tr,
      "icon": AppImages.categoriesIcon,
    },
    {"name" : "subMenuDrawer17".tr,
      "icon": AppImages.cartIcon,
    },
    {"name" : "subMenuDrawer18".tr,
      "icon": AppImages.couponIcon,
    },
  ];

  //Products sub menu list ; parent
  static List<Map<String,String>> subMenuListProducts = [
    {"name" : "subMenuDrawer19".tr},
    {"name" : "subMenuDrawer20".tr},
    {"name" : "subMenuDrawer21".tr},
    {"name" : "subMenuDrawer22".tr},
    {"name" : "subMenuDrawer23".tr},
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


  //payment options list
  static List<PaymentOptionModel> listOfPaymentsMethod = [
    PaymentOptionModel(id: 1, paymentOptionName: TypesOfPaymentMethod.servired, optionName: 'Servired/RedSys', ),
    PaymentOptionModel(id: 2, paymentOptionName: TypesOfPaymentMethod.bizum, optionName: 'Bizum'),
    PaymentOptionModel(id: 3, paymentOptionName: TypesOfPaymentMethod.paypal, optionName: 'PayPal'),
    PaymentOptionModel(id: 4, paymentOptionName: TypesOfPaymentMethod.cash, optionName: 'Dinero en efectivo'),
  ];


  //spain province
  static List<String> spainProvince = [
    "La Coruña",
    "Álava",
    "Albacete",
    "Alicante",
    "Almería",
    "Asturias",
    "Ávila",
    "Badajoz",
    "Baleares",
    "Barcelona",
    "Burgos",
    "Cáceres",
    "Cádiz",
    "Cantabria",
    "Castellón",
    "Ceuta",
    "Ciudad Real",
    "Córdoba",
    "Cuenca",
    "Gerona",
    "Granada",
    "Guadalajara",
    "Guipúzcoa",
    "Huelva",
    "Huesca",
    "Jaén",
    "La Rioja",
    "Las Palmas",
    "León",
    "Lérida",
    "Lugo",
    "Madrid",
    "Málaga",
    "Melilla",
    "Murcia",
    "Navarra",
    "Orense",
    "Palencia",
    "Pontevedra",
    "Salamanca",
    "Santa Cruz de Tenerife",
    "Segovia",
    "Sevilla",
    "Soria",
    "Tarragona",
    "Teruel",
    "Toledo",
    "Valencia",
    "Valladolid",
    "Vizcaya",
    "Zamora",
    "Zaragoza"
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

  //month in spanish
  static String getMonthInSpan(int month) {
    switch (month) {
      case 1:
        // return "enero";
        return "ene";
      case 2:
        // return "febrero";
        return "feb";
      case 3:
        // return "marzo";
        return "mar";
      case 4:
        // return "abril";
        return "abr";
      case 5:
        // return "mayo";
        return "may";
      case 6:
        // return "junio";
        return "jun";
      case 7:
        // return "julio";
        return "jul";
      case 8:
        // return "agosto";
        return "ago";
      case 9:
        // return "septiembre";
        return "sep";
      case 10:
        // return "octubre";
        return "oct";
      case 11:
        // return "noviembre";
        return "nov";
      default:
        // return "diciembre";
        return "dic";
    }
  }

  //list of spanish month
  static List<MonthModel> monthInSpanish = [
    MonthModel(id: 1, monthName: "Enero"),
    MonthModel(id: 2, monthName: "Febrero"),
    MonthModel(id: 3, monthName: 'Marzo'),
    MonthModel(id: 4, monthName: 'Abril'),
    MonthModel(id: 5, monthName: 'Mayo'),
    MonthModel(id: 6, monthName: "Junio"),
    MonthModel(id: 7, monthName: "Julio"),
    MonthModel(id: 8, monthName: "Agosto"),
    MonthModel(id: 9, monthName: "Septiembre"),
    MonthModel(id: 10, monthName: "Octubre"),
    MonthModel(id: 11, monthName: "Noviembre"),
    MonthModel(id: 12, monthName: "Diciembre")
  ];

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

class MonthModel{
  final int id;
  final String monthName;
  const MonthModel({required this.id,required this.monthName});
}

class PaymentOptionModel{
  final int id;
  final TypesOfPaymentMethod paymentOptionName;
  final String optionName;

  const PaymentOptionModel({required this.id,required this.paymentOptionName,required this.optionName,});


}