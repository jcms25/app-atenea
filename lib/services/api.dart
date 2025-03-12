import 'dart:convert';

import 'package:http/http.dart';

enum RequestType { post, get , delete}

class Api {

  static const String _baseURL = "https://colegioatenea.es/wp-json/scl-api/v1";

  // static const String _baseURL = "http://192.168.1.22/colegiaLive/wp-json/scl-api/v1";
  static String get localBaseURL => _baseURL;

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

  static const String  _teacherDetailsEndPoint = "teacher";
  static String get teacherDetailsEndPoint => _teacherDetailsEndPoint;

  static const String _studentEndpoint = "students";
  static String get studentEndpoint => _studentEndpoint;

  static const String _studentDetailsEndpoint = "student";
  static String get studentDetailsEndpoint => _studentDetailsEndpoint;


  static const String _teacherListForMessageSend = "teacherList";
  static String get teacherListForMessageSend => _teacherListForMessageSend;

  static const String _subjectEndpoint = "subjects";
  static String get subjectEndpoint => _subjectEndpoint;

  static const String _subjectDetailEndpoint = "subject";
  static String get subjectDetailEndpoint => _subjectDetailEndpoint;

  static const String _listOfAllMessages = "parentSendMessage";
  static String get listOfAllMessages => _listOfAllMessages;

  static const String _eventListEndpoint = "events";
  static String get eventListEndPoint => _eventListEndpoint;

  static const String _studentParentExamListPoint = "exams";
  static String get studentParentExamListPoint => _studentParentExamListPoint;

  static const String _examDetailEndPoint = "exam";
   static String get examDetailEndPoint => _examDetailEndPoint;

   static const String _evaluationEndPoint = "evaluation";
   static String get evaluationEndPoint => _evaluationEndPoint;

   static const String _evaluationPDFDownloadEndpoint = "evaluationpdf";
   static String get evaluationPDFDownloadEndpoint => _evaluationPDFDownloadEndpoint;


   static const String _updateStudentProfile = "update_student_profile";
   static String get updateStudentProfile => _updateStudentProfile;

   static const String _updateParentProfile = "update_parent_profile";
   static String get updateParentProfile => _updateParentProfile;

   static const String _updateTeacherProfile = "update_teacher_profile";
   static String get updateTeacherProfile => _updateTeacherProfile;

  //Teacher side end points
  // static const String _teacherEventsList = "teacher/events";
  // static String get teacherEventsList => _teacherEndpoint;

  static const String _teacherClassList = "teacher/classlist";
  static String get teacherClassList => _teacherClassList;

  static const String _teacherSubjectList = "teacher/subjectlist";
  static String get teacherSubjectList => _teacherSubjectList;

  static const String _teacherStudentList = "teacher/studentlist";
  static String get teacherStudentList => _teacherStudentList;

  static const String _teacherEventList = "teacher/events";
  static String get teacherEventList => _teacherEventList;

  static const String _teacherSideListOfProfessor = "teacher/teacherlist";
  static String get teacherSideListOfProfessor => _teacherSideListOfProfessor;

  static const String _teacherSideListOfParents = "teacher/parentist";
  static String get teacherSideListOfParents => _teacherSideListOfParents;

  static const String _teacherFollowedUp = "teacher/followup";
  static String get teacherFollowedUp => _teacherFollowedUp;

  static const String _teacherExamListPoint = "teacher/exams";
  static String get teacherExamListPoint => _teacherExamListPoint;

  static const String _teacherAddExamEndPoint = "exams";
  static String get teacherAddExamEndPoint => _teacherAddExamEndPoint;

  static const String _teacherEditExamEndPoint = "exam";
  static String get teacherEditExam => _teacherEditExamEndPoint;

  static const String _teacherMarksListEndPoint = "teacher/markslist";
  static String get teacherMarksListEndPoint => _teacherMarksListEndPoint;

  static const String _teacherMarksAddEditListEndPoint = "marks";
  static String get teacherMarksAddEditList => _teacherMarksAddEditListEndPoint;

  static const String _teacherMyScheduleEndPoint = "teacher/timetable";
  static String get teacherMyScheduleEndPoint => _teacherMyScheduleEndPoint;

  static const String _teacherDeleteExam = "exam";
  static String get teacherDeleteExam => _teacherDeleteExam;


  //store api :
  static const String _billingDetailEndPoint = "tiendaprofile";
  static String get billingDetailEndPoint => _billingDetailEndPoint;

  static const String _billingEditDetailEndPoint =   "tiendaeditprofile";
  static String get billingEditDetailEndPoint => _billingEditDetailEndPoint;

  static const String _orderListEndPoint = "tiendauserorders?user_id";
  static String get orderListEndPoint => _orderListEndPoint;

  static const String _orderDetailEndPoint = "tiendaUserorderdetails?order_id";
  static String get orderDetailEndPoint => _orderDetailEndPoint;


  //Dinning Section
  static const String _dinningSectionEndPoint = "diningmenu";
  static String get dinningSectionEndPoint => _dinningSectionEndPoint;

  static const String _dinningStudentListEndPoint = "diningstudents";
  static String get dinningStudentListEndPoint => _dinningStudentListEndPoint;

  static const String _addEditDinningTeacherSide = "diningservice";
  static String get addEditDinningTeacherSide => _addEditDinningTeacherSide;

  static const String _dinningDaysList = "schoolcalendardays";
  static String get dinningDaysList => _dinningDaysList;

  static Future<Map<String, dynamic>> httpRequest(
      {required RequestType requestType,
      required String endPoint,
      Map<String, String>? header,
      Map<String, dynamic>? body}) async {

    try {
      Response response;
      if (requestType == RequestType.get) {
        response = await get(Uri.parse("$_baseURL/$endPoint"), headers: header,);
      } else if (requestType == RequestType.delete){
        response = await delete(Uri.parse("$_baseURL/$endPoint"),headers: header);
      }
      else {
        response = await post(Uri.parse("$_baseURL/$endPoint"),
            headers: header, body: body);
      }
      if (response.statusCode == 200) {
        dynamic res = jsonDecode(response.body);
        return res;
      }
      else if (response.statusCode == 401) {
        return {"status": false, "message": "No autorizado"};
      }
      else {
        return {"status": false, "message": "Por favor, inténtalo de nuevo"};
      }

    } catch (exception) {
      return {"status": false, "message": '$exception'};
    }



  }
}
