import 'package:colegia_atenea/models/dashboard_model.dart';
import 'package:colegia_atenea/models/list_of_messages_model.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/models/single_subject_detail_model.dart';
import 'package:colegia_atenea/models/subject_list_model.dart';
import 'package:colegia_atenea/models/teacher_list_model.dart';
import 'package:colegia_atenea/models/timetable_model.dart';
import 'package:colegia_atenea/models/transport_list_model.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/teacher/teacher_class_model.dart';
import '../models/student_list_model.dart';
import '../services/api.dart';

enum RoleType { student, parent, teacher, assistant }

class StudentParentTeacherController extends ChangeNotifier {
  //Loader visibility handler
  bool isLoading = false;

  void setIsLoading({required bool isLoading}) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  //current logged in role
  RoleType? currentLoggedInUserRole;

  void setRole({required RoleType? role}) {
    currentLoggedInUserRole = role;
    notifyListeners();
  }

  //current logged in user data
  LoginModel? loginModel;

  void setLoginModel({required LoginModel? loginModel}) {
    this.loginModel = loginModel;
    notifyListeners();
  }

  //current bottom Index selected
  int currentBottomIndexSelected = 0;

  void setCurrentBottomIndexSelected({required int index}) {
    currentBottomIndexSelected = index;
    notifyListeners();
  }

  //open forgot password link
  Future<void> openUrl() async {
    try {
      var url = Uri.parse(
          "http://colegioatenea.es/solicitud-de-credenciales-de-acceso/");
      if (!await launchUrl(url)) {
        AppConstants.showCustomToast(
            status: false, message: 'Can\'t Launch URL');
      }
    } catch (e) {
      AppConstants.showCustomToast(status: false, message: "$e");
    }
  }

  //Dashboard
  Dashboard? dashboard;

  void setDashboardData({required Dashboard? dashboard}) {
    this.dashboard = dashboard;
    notifyListeners();
  }

  List<EventItem> examList = [];
  List<EventItem> events = [];
  List<EventItem> holiday = [];

  //exam list
  void setExamList({required List<EventItem> examList}) {
    this.examList = examList;
    notifyListeners();
  }

  //event list
  void setEventList({required List<EventItem> events}) {
    this.events = events;
    notifyListeners();
  }

  //holiday list
  void setHolidayList({required List<EventItem> holiday}) {
    this.holiday = holiday;
    notifyListeners();
  }

  //for showing list in calendar
  int currentListToShowInCalendar = 1;

  void setCurrentListToShowInCalendar(
      {required int currentListToShowInCalendar}) {
    this.currentListToShowInCalendar = currentListToShowInCalendar;
    notifyListeners();
  }

  //calendar handler
  DateTime focusDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  //set focus day
  void setFocusDay({required DateTime focusDay}) {
    this.focusDay = focusDay;
    notifyListeners();
  }

  //set selected day
  void setSelectedDay({required DateTime selectedDay}) {
    this.selectedDay = selectedDay;
    notifyListeners();
  }

  //get dashboard data
  void getDashboardData({required bool showLoader}) async {
    try {
      setIsLoading(isLoading: showLoader);
      await Api.httpRequest(
        requestType: RequestType.get,
        endPoint: Api.dashboardEndpoint,
        header: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': "Basic ${loginModel?.basicAuthToken}",
          'Cookie': loginModel?.userdata?.cookies ?? ""
        },
      ).then((response) {
        if (response['status']) {
          Dashboard dashboard = Dashboard.fromJson(response);
          setDashboardData(dashboard: dashboard);
          setExamList(examList: dashboard.eventList.exams);
          setEventList(events: dashboard.eventList.events);
          setHolidayList(holiday: dashboard.eventList.holiday);
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //Communication Section :
  ListOfMessagesModel? listOfMessagesModel;
  List<MessageItem> receivedMessageList = [];
  List<MessageItem> sendMessageList = [];
  List<MessageItem> tempMessageList = [];

  void setMessageList(
      {required List<MessageItem> listOfMessage,
      required int messageListType}) {
    //messageListType -> 0 : received list , 1 : sender list
    messageListType == 0
        ? receivedMessageList = listOfMessage
        : sendMessageList = listOfMessage;
    notifyListeners();
  }

  void setListOfMessageModel(
      {required ListOfMessagesModel? listOfMessagesModel}) {
    this.listOfMessagesModel = listOfMessagesModel;
    notifyListeners();
  }

  //received or sent
  String currentSelectedMessageListType = "Recibidas";

  void setCurrentSelectedMessageType(
      {required String currentSelectedMessageListType}) {
    this.currentSelectedMessageListType = currentSelectedMessageListType;
    if (currentSelectedMessageListType == "Recibidas") {
      tempMessageList = receivedMessageList;
    } else {
      tempMessageList = sendMessageList;
    }
    notifyListeners();
  }

  void getMessageList({required bool showLoader}) async {
    try {
      setIsLoading(isLoading: showLoader);
      String token = loginModel?.basicAuthToken ?? "";
      String cookies = loginModel?.userdata?.cookies ?? "";

      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: Api.listOfAllMessages,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookies
          }).then((response) {
        if (response['status']) {
          ListOfMessagesModel listOfMessages =
              ListOfMessagesModel.fromJson(response);
          setListOfMessageModel(listOfMessagesModel: listOfMessages);
          setMessageList(
              listOfMessage: listOfMessages.data?.receivedMessages ?? [],
              messageListType: 0);
          setMessageList(
              listOfMessage: listOfMessages.data?.sendMessages ?? [],
              messageListType: 1);
          currentSelectedMessageListType == "Recibidas"
              ? tempMessageList = receivedMessageList
              : tempMessageList = sendMessageList;
          notifyListeners();
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  void searchInMessageList(String? value) {
    if (value?.isEmpty ?? true) {
      tempMessageList = currentSelectedMessageListType == "Recibidas"
          ? receivedMessageList
          : sendMessageList;
      notifyListeners();
      return;
    }

    List<MessageItem> searchData = [];
    if (currentSelectedMessageListType == "Recibidas") {
      for (var messageData in receivedMessageList) {
        if (messageData.subject
                ?.toLowerCase()
                .contains(value?.toLowerCase() ?? "") ??
            false ||
                DateFormat("dd/MM/yy")
                    .format(DateTime.parse(messageData.mDate ?? ""))
                    .contains(value ?? "")) {
          searchData.add(messageData);
        }
      }
    } else {
      for (var messageData in sendMessageList) {
        if (messageData.subject
                ?.toLowerCase()
                .contains(value?.toLowerCase() ?? "") ??
            false ||
                DateFormat("dd/MM/yy")
                    .format(DateTime.parse(messageData.mDate ?? ""))
                    .contains(value ?? "")) {
          searchData.add(messageData);
        }
      }
    }

    tempMessageList = searchData;
    notifyListeners();
  }

  /*
  Child communication list at parent side on click of submenu
  */
  List<MessageItem> listOfChildCommunication = [];

  void setListOfChildCommunication(
      {required List<MessageItem> listOfChildCommunication}) {
    this.listOfChildCommunication = listOfChildCommunication;
    notifyListeners();
  }

  void getListOfChildCommunication({required String wpUserId}) async {
    try {
      setIsLoading(isLoading: true);
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: "${Api.childCommunicationEndpoint}?sid=$wpUserId",
          header: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          }).then((response) {
        if (response['status']) {
          ListOfMessagesModel listOfMessagesModel =
              ListOfMessagesModel.fromJson(response);
          setListOfChildCommunication(
              listOfChildCommunication:
                  listOfMessagesModel.data?.receivedMessages ?? []);
        }
        setIsLoading(isLoading: false);
      });
    } catch (e) {
      setIsLoading(isLoading: false);
    }
  }

  //Subject section :
  List<SubjectItem> listOfStudentSubject = [];
  List<SubjectItem> tempListOfStudentSubject = [];

  void setListOfStudentSubject(
      {required List<SubjectItem> listOfStudentSubject}) {
    this.listOfStudentSubject = listOfStudentSubject;
    tempListOfStudentSubject = listOfStudentSubject;
    notifyListeners();
  }

  void setTempListOfStudentSubject(
      {required List<SubjectItem> tempListOfStudentSubject}) {
    this.tempListOfStudentSubject = tempListOfStudentSubject;
    notifyListeners();
  }

  void getListOfStudentSubjects(
      {required String classId, required String wpId}) async {
    try {
      setIsLoading(isLoading: true);
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint:
              "${Api.subjectEndpoint}?student_id=$wpId${'&class_id=$classId'}",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic ${loginModel?.basicAuthToken}",
            'Cookie': "${loginModel?.userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          SubjectListModel subjectList = SubjectListModel.fromJson(response);
          setListOfStudentSubject(
              listOfStudentSubject: subjectList.subjectlist ?? []);
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //search subject in list
  void searchInSubjectList(String? value) {
    if (value?.isEmpty ?? true) {
      setTempListOfStudentSubject(
          tempListOfStudentSubject: listOfStudentSubject);
      return;
    }

    List<SubjectItem> searchData = [];
    for (var subject in listOfStudentSubject) {
      if (subject.subName?.toLowerCase().contains(value?.toLowerCase() ?? "") ??
          false) {
        searchData.add(subject);
      }
    }

    setTempListOfStudentSubject(tempListOfStudentSubject: searchData);
  }

  //subject details
  Subject? subject;

  void setSubject({required Subject? subject}) {
    this.subject = subject;
    notifyListeners();
  }

  SubjectDetail? subjectDetail;

  void setSubjectDetails({required SubjectDetail? subjectDetail}) {
    this.subjectDetail = subjectDetail;
    notifyListeners();
  }

  //get subject details
  void getSingleSubjectDetails({required String subjectId}) async {
    try {
      setIsLoading(isLoading: true);
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: "${Api.subjectDetailEndpoint}/$subjectId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic ${loginModel?.basicAuthToken}",
            'Cookie': "${loginModel?.userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          Subject subject = Subject.fromJson(response);
          setSubject(subject: subject);
          setSubjectDetails(subjectDetail: subject.data?[0]);
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //Time table section :
  List<TimeTableItem> timeTableList = [];
  List<TimeTableItemData> particularDayTimeTableData = [];
  List<TimeTableItemData> tempParticularDayTimeTableData = [];

  void setTimeTableList({required List<TimeTableItem> timeTableList}) {
    this.timeTableList = timeTableList;
    notifyListeners();
  }

  void setParticularDayTimeTableData(
      {required List<TimeTableItemData> particularDayTimeTableData}) {
    this.particularDayTimeTableData = particularDayTimeTableData;
    tempParticularDayTimeTableData = particularDayTimeTableData;
    notifyListeners();
  }

  //this will used into show on screen (searched data as well as all data)
  void setTempParticularDayTimeTableData(
      {required List<TimeTableItemData> tempParticularDayTimeTableData}) {
    this.tempParticularDayTimeTableData = tempParticularDayTimeTableData;
    notifyListeners();
  }

  //get current day
  static int getCurrentDay() {
    DateTime date = DateTime.now();
    if (date.weekday == 6 || date.weekday == 7 || date.weekday == 1) {
      return 1;
    } else {
      return date.weekday;
    }
  }

  //current day
  int currentSelectedDay = getCurrentDay() - 1;

  void setCurrentSelectedDay({required int currentSelectedDay}) {
    this.currentSelectedDay = currentSelectedDay;
    notifyListeners();
  }

  //student info
  StudentInfo? studentInfo;

  void setStudentInfo({required StudentInfo? studentInfo}) {
    this.studentInfo = studentInfo;
    notifyListeners();
  }

  //get time table data
  void getTimeTableData(
      {required String classId, required String studentId}) async {
    try {
      setIsLoading(isLoading: true);
      dynamic response = await Api.httpRequest(
          requestType: RequestType.get,
          endPoint:
              "${Api.timeTableEndpoint}/$classId?cid=$classId&sid=$studentId",
          header: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic ${loginModel?.basicAuthToken}",
            'Cookie': "${loginModel?.userdata?.cookies}"
          });
      int currentDay = getCurrentDay() - 1;
      setCurrentSelectedDay(currentSelectedDay: currentDay);
      if (response['status']) {
        TimeTable timeTable = TimeTable.fromJson(response);
        setTimeTableList(timeTableList: timeTable.sessionList ?? []);
        setParticularDayTimeTableData(
            particularDayTimeTableData:
                timeTableList[currentSelectedDay].data ?? []);
        setStudentInfo(studentInfo: timeTable.stuentInfo);
        setIsLoading(isLoading: false);
      } else {
        setIsLoading(isLoading: false);
        AppConstants.showCustomToast(
            status: false, message: response['message']);
      }
      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //search time table data
  void searchInTimeTableData(String? value) {
    if (value?.isEmpty ?? true) {
      setTempParticularDayTimeTableData(
          tempParticularDayTimeTableData: particularDayTimeTableData);
      return;
    }

    List<TimeTableItemData> searchData = [];
    for (var userDetail in particularDayTimeTableData) {
      String subNameString = userDetail.subName!.join("\n");
      // bool checkExist = userDetail!.subName!.where((element) {
      //   return element!.isCaseInsensitiveContains(text);
      // }).isNotEmpty;
      subNameString.replaceAll("\n", " ");
      if (subNameString.contains(value ?? "")) {
        searchData.add(userDetail);
      }
    }

    setTempParticularDayTimeTableData(
        tempParticularDayTimeTableData: searchData);
  }

  //get bilingual and non-bilingual subjects according to student
  String getSubjectName({required List<String> subjectName}) {
    String? studentIsBilingualOrNonBilingual = studentInfo?.langType;
    if (studentIsBilingualOrNonBilingual != null &&
        studentIsBilingualOrNonBilingual == "0") {
      for (var e in subjectName) {
        if (e.contains("No Bilingüe")) {
          return e;
        }
      }
    } else {
      for (var e in subjectName) {
        if (e.contains("Bilingüe") && !e.contains("No Bilingüe")) {
          return e;
        }
      }
    }
    return studentIsBilingualOrNonBilingual == null
        ? subjectName.join("\n")
        : "";
  }

  //get list of professor
  List<TeacherItem> listOfTeachers = [];
  List<TeacherItem> tempListOfTeachers = [];

  void setListOfTeachers({required List<TeacherItem> listOfTeachers}) {
    this.listOfTeachers = listOfTeachers;
    tempListOfTeachers = listOfTeachers;
    notifyListeners();
  }

  void setTempListOfTeachers({required List<TeacherItem> listOfTeachers}) {
    tempListOfTeachers = listOfTeachers;
    notifyListeners();
  }

  void getListOfTeachers(
      {required String studentId, required String classId}) async {
    try {
      setIsLoading(isLoading: true);

      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint:
              "${Api.teacherEndpoint}?student_id=$studentId&class_id=$classId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic ${loginModel?.basicAuthToken}",
            'Cookie': "${loginModel?.userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          Teacher teacher = Teacher.fromJson(response);
          setListOfTeachers(listOfTeachers: teacher.teacherlist ?? []);
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //search in teacher list
  void searchInTeacherList(String? value) {
    if (value?.isEmpty ?? true) {
      setTempListOfTeachers(listOfTeachers: listOfTeachers);
      return;
    }

    List<TeacherItem> searchData = [];
    for (var teacherItem in listOfTeachers) {
      if (teacherItem.firstName!
              .toLowerCase()
              .contains(value?.toLowerCase() ?? "") ||
          teacherItem.lastName!
              .toLowerCase()
              .contains(value?.toLowerCase() ?? "")) {
        searchData.add(teacherItem);
      }
    }

    setTempListOfTeachers(listOfTeachers: searchData);
  }

  //Student List Screen :
  List<StudentItem> listOfStudents = [];
  List<StudentItem> tempListOfStudents = [];

  void setListOfStudents({required List<StudentItem> listOfStudents}) {
    this.listOfStudents = listOfStudents;
    tempListOfStudents = listOfStudents;
    notifyListeners();
  }

  void setTempListOfStudents({required List<StudentItem> tempListOfStudents}) {
    this.tempListOfStudents = tempListOfStudents;
    notifyListeners();
  }

  void getListOfStudents({required String classId}) async {
    try {
      setIsLoading(isLoading: true);
      print(classId);
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: "${Api.studentEndpoint}?class_id=$classId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic ${loginModel?.basicAuthToken}",
            'Cookie': "${loginModel?.userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          StudentListModel student = StudentListModel.fromJson(response);
          List<StudentItem> studentItemList = student.studentlist ?? [];
          studentItemList.sort((a,b) => a.sLname?.compareTo(b.sLname ?? "") ?? 0);
          setListOfStudents(listOfStudents: student.studentlist ?? []);
          setIsLoading(isLoading: false);
        }
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  void searchInStudentList(String? value) {
    if (value?.isEmpty ?? true) {
      setTempListOfStudents(tempListOfStudents: listOfStudents);
      return;
    }

    List<StudentItem> searchData = [];
    for (var studentItem in listOfStudents) {
      if (studentItem.sFname!
              .toLowerCase()
              .contains(value?.toLowerCase() ?? "") ||
          studentItem.sRollno!
              .toLowerCase()
              .contains(value?.toLowerCase() ?? "") ||
          studentItem.sLname!
              .toLowerCase()
              .contains(value?.toLowerCase() ?? "")) {
        searchData.add(studentItem);
      }
    }

    setTempListOfStudents(tempListOfStudents: searchData);
  }

  //Transport section :
  List<TransportItem> tempTransportList = [];
  List<TransportItem> transportList = [];

  void setTransportItem({required List<TransportItem> transportList}) {
    this.transportList = transportList;
    notifyListeners();
  }

  void setTempTransportList({required List<TransportItem> transportList}) {
    tempTransportList = transportList;
    notifyListeners();
  }

  //get transport data
  void getTransportData() async {
    try {
      setIsLoading(isLoading: true);
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: Api.transportEndpoint,
          header: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic ${loginModel?.basicAuthToken}",
            'Cookie': loginModel?.userdata?.cookies ?? ""
          }).then((response) {
        if (response['status']) {
          Transport transport = Transport.fromJson(response);
          setTransportItem(transportList: transport.data);
          setTempTransportList(transportList: transport.data);
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //searching in transport screen
  void searchInTransportData(String? value) {
    if (value?.isEmpty ?? true) {
      setTempTransportList(transportList: transportList);
      return;
    }

    List<TransportItem> searchData = [];
    for (var userDetail in transportList) {
      if (userDetail.driverName.toLowerCase() == value?.toLowerCase() ||
          userDetail.busNo.toLowerCase() == value?.toLowerCase()) {
        searchData.add(userDetail);
      }
    }

    setTempTransportList(transportList: searchData);
  }


  //Logged out function : clear all controller data
  void loggedOutClearData() {
    currentLoggedInUserRole = null;
    loginModel = null;
    setCurrentBottomIndexSelected(index: 0);
    timeTableList = [];
    particularDayTimeTableData = [];
    tempParticularDayTimeTableData = [];
    studentInfo = null;
    tempTransportList = [];
    transportList = [];
    listOfStudentSubject = [];
    tempListOfStudentSubject = [];
    subjectDetail = null;
    subject = null;
    notifyListeners();
  }

  //log out user
  void logOutUser() async {}




  //Teacher Section :
  List<TeacherClassItem> listOfClassAssignToTeacher = [];

  void setListOfClassAssignToTeacher({required List<TeacherClassItem> listOfClassAssignToTeacher}) async{
    this.listOfClassAssignToTeacher = listOfClassAssignToTeacher;
    notifyListeners();
  }

  void getListOfClassesAssignToTeacher({required bool showLoader}) async{
    try{
      setIsLoading(isLoading: showLoader);
      
      await Api.httpRequest(requestType: RequestType.get, endPoint: Api.teacherClassList, header: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Authorization': "Basic ${loginModel?.basicAuthToken}",
        'Cookie': loginModel?.userdata?.cookies ?? ""
      }).then((res){
        if(res['status']){
          print(res);
          TeacherClassListModel teacherClass = TeacherClassListModel.fromJson(res);
          setListOfClassAssignToTeacher(listOfClassAssignToTeacher: teacherClass.data ?? []);
        }
        setIsLoading(isLoading: false);
      });
      
      setIsLoading(isLoading: false);
    }catch(exception){
      setIsLoading(isLoading: false);
    }
  }

}
