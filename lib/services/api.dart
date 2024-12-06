import 'dart:convert';

import 'package:http/http.dart';

enum RequestType { post, get }

class Api {
  static const String _baseURL = "https://colegioatenea.es/wp-json/scl-api/v1";

  static const String _loginEndpoint = "login";
  static String get loginEndPoint => _loginEndpoint;

  static const String _logoutEndpoint = "logout";
  static String get logoutEndPoint => _logoutEndpoint;

  static const String _dashboardEndpoint = "dashboard/";
  static String get dashboardEndpoint => _dashboardEndpoint;

  static const String _childCommunicationEndpoint = "studentmessages";
  static String get childCommunicationEndpoint => _childCommunicationEndpoint;

  static const String _transportEndpoint = "transports";
  static String get transportEndpoint => _transportEndpoint;

  static const String _timeTableEndpoint = "timetable";
  static String get timeTableEndpoint => _timeTableEndpoint;

  static const String _teacherEndpoint = "teachers";
  static String get teacherEndpoint => _teacherEndpoint;

  static const String _studentEndpoint = "students";
  static String get studentEndpoint => _studentEndpoint;


  static const String _subjectEndpoint = "subjects";
  static String get subjectEndpoint => _subjectEndpoint;

  static const String _subjectDetailEndpoint = "subject";
  static String get subjectDetailEndpoint => _subjectDetailEndpoint;

  static const String _listOfAllMessages = "parentSendMessage";
  static String get listOfAllMessages => _listOfAllMessages;




  //Teacher side end points
  static const String _teacherEventsList = "teacher/events";
  static String get teacherEventsList => _teacherEndpoint;

  static const String _teacherClassList = "teacher/classlist";
  static String get teacherClassList => _teacherClassList;

  static const String _teacherAddEditEvent = "events";
  static String get teacherAddEditEvent => _teacherAddEditEvent;


  static Future<Map<String, dynamic>> httpRequest(
      {required RequestType requestType,
      required String endPoint,
      required Map<String, String>? header,
      Map<String, dynamic>? body}) async {
    try {
      Response response;
      if (requestType == RequestType.get) {
        response = await get(Uri.parse("$_baseURL/$endPoint"), headers: header);
      } else {
        response = await post(Uri.parse("$_baseURL/$endPoint"),
            headers: header, body: body);
      }
      if (response.statusCode == 200) {
        dynamic res = jsonDecode(response.body);
        return res;
      } else if (response.statusCode == 401) {
        return {"status": false, "message": "No autorizado"};
      } else {
        return {"status": false, "message": "Por favor, inténtalo de nuevo"};
      }
    } catch (exception) {
      return {"status": false, "message": '$exception'};
    }
  }
}
