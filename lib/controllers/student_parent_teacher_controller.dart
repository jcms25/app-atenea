import 'dart:convert';

import 'package:colegia_atenea/models/dashboard_model.dart';
import 'package:colegia_atenea/models/dinning_student_list_response.dart';
import 'package:colegia_atenea/models/dinning_menu_response.dart';
import 'package:colegia_atenea/models/evaluation_list_model.dart';
import 'package:colegia_atenea/models/exam_detail_model.dart';
import 'package:colegia_atenea/models/exam_list_model.dart';
import 'package:colegia_atenea/models/followed_up_model.dart';
import 'package:colegia_atenea/models/get_teacher_list_send_message_model.dart';
import 'package:colegia_atenea/models/list_of_messages_model.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/models/single_message_detail_model.dart';
import 'package:colegia_atenea/models/single_subject_detail_model.dart';
import 'package:colegia_atenea/models/single_teacher_details_model.dart';
import 'package:colegia_atenea/models/student_details_model.dart';
import 'package:colegia_atenea/models/subject_list_model.dart';
import 'package:colegia_atenea/models/teacher/parent_list_model.dart';
import 'package:colegia_atenea/models/teacher/teacher_dinning_month_list_model.dart';
import 'package:colegia_atenea/models/teacher/teacher_marks_list_model.dart';
import 'package:colegia_atenea/models/teacher/teacher_schedule_model.dart';
import 'package:colegia_atenea/models/teacher_list_model.dart';
import 'package:colegia_atenea/models/timetable_model.dart';
import 'package:colegia_atenea/models/transport_list_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, Response;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/events_list.dart';
import '../models/student_list_model.dart';
import '../models/teacher/teacher_class_model.dart';
import '../services/api.dart';

enum RoleType { student, parent, teacher, assistant }

class StudentParentTeacherController extends ChangeNotifier {
  //Loader visibility handler
  bool isLoading = false;

  void setIsLoading({required bool isLoading}) {
    this.isLoading = isLoading;
    notifyListeners();
  }



  //is bottom sheet loader
  bool isBottomLoader = false;

  void setIsBottomLoader({required bool isBottomLoader}){
    this.isBottomLoader = isBottomLoader;
    notifyListeners();
  }

  //current logged in role
  RoleType? currentLoggedInUserRole;

  void setRole({required RoleType? role}) {
    currentLoggedInUserRole = role;
    notifyListeners();
  }

  //current logged in user data
  Userdata? userdata;

  void setLoginModel({required Userdata? userdata}) {
    this.userdata = userdata;
    notifyListeners();
  }

  //current bottom Index selected
  int currentBottomIndexSelected = 0;

  void setCurrentBottomIndexSelected({required int index}) {
    currentBottomIndexSelected = index;
    notifyListeners();
  }

  //open forgot password link
  Future<void> openUrl({required String url}) async {
    try {
      var uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        AppConstants.showCustomToast(status: false, message: "canNot".tr);
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

  List<EventItem> dashboardExamList = [];
  List<EventItem> dashboardEvents = [];
  List<EventItem> dashboardHoliday = [];

  //exam list
  void setExamList({required List<EventItem> examList}) {
    dashboardExamList = examList;
    notifyListeners();
  }

  //event list
  void setEventList({required List<EventItem> events}) {
    dashboardEvents = events;
    notifyListeners();
  }

  //holiday list
  void setHolidayList({required List<EventItem> holiday}) {
    dashboardHoliday = holiday;
    notifyListeners();
  }

  //dashboard event map
  Map<DateTime, List<EventItemDetail>> dashboardEventMap = {};

  void setDashboardEventsMap(
      {required Map<DateTime, List<EventItemDetail>> eventMap}) {
    dashboardEventMap = eventMap;
    notifyListeners();
  }

  void setDashboardEvents({required int dashboardActivitiesToShow}) {
    Map<DateTime, List<EventItemDetail>> eventMap = {};
    DateFormat df = DateFormat("yyyy-MM-dd");

    if (dashboardActivitiesToShow == 1) {
      for (EventItem e in dashboardEvents) {
        if (eventMap.keys.contains(DateTime.parse(df.format(e.startDate)))) {
          eventMap[DateTime.parse(df.format(e.startDate))]?.addAll(e.list);
        } else {
          eventMap[DateTime.parse(df.format(e.startDate))] = e.list;
        }
      }
    } else if (dashboardActivitiesToShow == 2) {
      for (EventItem e in dashboardExamList) {
        if (eventMap[DateTime.parse(df.format(e.startDate))] != null) {
          eventMap[DateTime.parse(df.format(e.startDate))]?.addAll(e.list);
        } else {
          eventMap[DateTime.parse(df.format(e.startDate))] = e.list;
        }
      }
    } else {
      for (EventItem e in dashboardHoliday) {
        if (eventMap[DateTime.parse(df.format(e.startDate))] != null) {
          eventMap[DateTime.parse(df.format(e.startDate))]?.addAll(e.list);
        } else {
          eventMap[DateTime.parse(df.format(e.startDate))] = e.list;
        }
      }
    }
    setDashboardEventsMap(eventMap: eventMap);
  }

  //get events for dashboard
  List<EventItemDetail> getDashboardEvents(DateTime date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    List<EventItemDetail>? events =
        dashboardEventMap[DateTime.parse(dateFormat.format(date))]
                    .runtimeType ==
                EventItemDetail
            ? dashboardEventMap[DateTime.parse(dateFormat.format(date))]
            : dashboardEventMap[DateTime.parse(dateFormat.format(date))];

    // List<EventItemDetail> events = dashboardEventMap[DateTime.parse(dateFormat.format(date))] ?? [];
    return events ?? [];
  }

  //get dashboard data
  void getDashboardData({required bool showLoader}) async {
    try {
      setIsLoading(isLoading: showLoader);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      String userRole = userdata?.userRole ?? "";
      await Api.httpRequest(
        requestType: RequestType.get,
        endPoint: "${Api.dashboardEndpoint}?current_role=$userRole",
        header: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': "Basic $token",
          'Cookie': userdata?.cookies ?? ""
        },
      ).then((response) {
        if (response['status']) {
          Dashboard dashboard = Dashboard.fromJson(response);
          setDashboardData(dashboard: dashboard);
          setExamList(examList: dashboard.eventList.exams);
          setEventList(events: dashboard.eventList.events);
          setHolidayList(holiday: dashboard.eventList.holiday);

          setDashboardEvents(
              dashboardActivitiesToShow: dashboardActivitiesToShow);
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }

  }

  //calendar handler
  DateTime dashboardCalendarFocusDay = DateTime.now();

  void setDashboardCalendarFocusDay({required DateTime focusDay}) {
    dashboardCalendarFocusDay = focusDay;
    notifyListeners();
  }

  DateTime dashboardCalendarSelectedDay = DateTime.now();

  void setDashboardCalendarSelectedDay({required DateTime selectedDay}) {
    dashboardCalendarSelectedDay = selectedDay;
    notifyListeners();
  }

  //set focus day
  void setFocusDay({required DateTime focusDay}) {
    dashboardCalendarFocusDay = focusDay;
    notifyListeners();
  }

  //set selected day
  void setSelectedDay({required DateTime selectedDay}) {
    dashboardCalendarSelectedDay = selectedDay;
    notifyListeners();
  }

  //category to show in calendar of activities
  //1 -> Events , 2 -> Examen , 3-> Holidays/Vacations
  int dashboardActivitiesToShow = 1;

  void setDashboardActivitiesToShow({required int dashboardActivitiesToShow}) {
    this.dashboardActivitiesToShow = dashboardActivitiesToShow;
    notifyListeners();
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
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      String cookies = userdata?.cookies ?? "";
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

  //Message Details
  MessageDetailItem? messageDetailItem;

  void setMessageDetailItem({required MessageDetailItem? messageDetailItem}) {
    this.messageDetailItem = messageDetailItem;
    notifyListeners();
  }

  void getMessageDetails({required String messageId}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: "${Api.listOfAllMessages}?mid=$messageId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': "${userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          MessageDetails messageDetails = MessageDetails.fromJson(response);
          setMessageDetailItem(messageDetailItem: messageDetails.data);
        }
        AppConstants.showCustomToast(
            status: response['status'], message: response['Message'] ?? "");
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //student and parent side teacher list
  List<TeacherItemForSendMessage> teacherListForMessageSend = [];

  void setListOfTeacherForMessageSend(
      {required List<TeacherItemForSendMessage> teacherListForMessageSend}) {
    this.teacherListForMessageSend = teacherListForMessageSend;
    notifyListeners();
  }

  TeacherItemForSendMessage? currentSelectedTeacherForMessageSend;

  void setCurrentSelectedTeacherForMessageSend(
      {required TeacherItemForSendMessage?
          currentSelectedTeacherForMessageSend}) {
    this.currentSelectedTeacherForMessageSend =
        currentSelectedTeacherForMessageSend;
    notifyListeners();
  }

  //list of teacher to send message from parent and student
  void getListOfTeacherForMessageSend({String? teacherId}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: Api.teacherListForMessageSend,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': "${userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          TeacherListForSend teacherListForSend =
              TeacherListForSend.fromJson(response);
          setListOfTeacherForMessageSend(
              teacherListForMessageSend: teacherListForSend.data);
          if (teacherListForSend.data.isNotEmpty) {
            if (teacherId != null && teacherId.isNotEmpty) {
              for (TeacherItemForSendMessage e in teacherListForSend.data) {
                if (e.wpUsrId == teacherId) {
                  setCurrentSelectedTeacherForMessageSend(
                      currentSelectedTeacherForMessageSend: e);
                  break;
                }
              }
            } else {
              currentSelectedTeacherForMessageSend = teacherListForSend.data[0];
            }
          }
          setIsLoading(isLoading: false);
        }
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //selected file path
  String? selectedFilePath;

  void setSelectedFilePath({required String? selectedFilePath}) {
    this.selectedFilePath = selectedFilePath;
    notifyListeners();
  }

  //whom to send radio button : parent,student (choice for teacher)
  MessageSendCategoryForTeacher? currentSendingMessageCategory;

  void setCurrentSendingMessageCategory(
      {required MessageSendCategoryForTeacher?
          messageSendingCategoryForTeacher}) {
    if (currentSelectedStudentForSendMessage != null) {
      setCurrentSelectedStudentForSendMessage(studentItem: null);
    }
    if (currentSelectedParentForSendMessage != null) {
      setCurrentSelectedParentForSendMessage(parentItem: null);
    }
    currentSendingMessageCategory = messageSendingCategoryForTeacher;
    notifyListeners();
  }

  //selected student for sending message
  StudentItem? currentSelectedStudentForSendMessage;

  void setCurrentSelectedStudentForSendMessage(
      {required StudentItem? studentItem}) {
    currentSelectedStudentForSendMessage = studentItem;
    notifyListeners();
  }

  //selected parent for sending message
  ParentItem? currentSelectedParentForSendMessage;

  void setCurrentSelectedParentForSendMessage(
      {required ParentItem? parentItem}) {
    currentSelectedParentForSendMessage = parentItem;
    notifyListeners();
  }

  //send message to teacher
  Future<Map<String, dynamic>> sendMessage(
      {required String messageSubject,
      required String description,
      required int whomToSend,
      String? classId,
      String? toAllParent,
      String? toAllStudent}) async {
    //0 : to Teacher (Logged in with student,parent)
    //1 : to Parent (Logged in with teacher)
    //2 : to Student (Logged in with teacher)

    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      final MultipartRequest request = MultipartRequest(
          'POST', Uri.parse('${Api.localBaseURL}/parentSendMessage'));
      request.headers.addAll({
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Authorization': "Basic $token",
        'Cookie': "${userdata?.cookies}"
      });

      if (selectedFilePath?.isEmpty ?? true) {
        request.fields['attachment'] = "";
      } else {
        request.files.add(
            await MultipartFile.fromPath('attachment', selectedFilePath ?? ""));
      }

      request.fields['sender_id'] = currentLoggedInUserRole == RoleType.parent
          ? userdata?.parentWpUsrId ?? ""
          : userdata?.wpUsrId ?? "";

      if (classId != null) {
        request.fields['classid'] = classId;
        request.fields['studentall'] = toAllStudent ?? "";
        request.fields['parentall'] = toAllParent ?? "";
      } else {
        request.fields['reciever_id[0]'] = whomToSend == 0
            ? currentSelectedTeacherForMessageSend?.wpUsrId ?? ""
            : whomToSend == 1
                ? currentSelectedParentForSendMessage?.parentWpUsrId ?? ""
                : currentSelectedStudentForSendMessage?.wpUsrId ?? "";
      }

      request.fields['subject'] = messageSubject;
      request.fields['msg'] = description;

      StreamedResponse streamResponse = await request.send();
      var response = await Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        AppConstants.showCustomToast(
            status: data['status'],
            message: data['Message'] ?? data['message'] ?? "");
        setIsLoading(isLoading: false);
        return {
          "status": data['status'],
          "message": data['Message'] ?? data['message'] ?? ""
        };
      } else {
        setIsLoading(isLoading: false);
        AppConstants.showCustomToast(
            status: false, message: "${response.statusCode}");
        return {"status": false, "message": "Please try again."};
      }
    } catch (exception) {
      setIsLoading(isLoading: false);
      return {"status": false, "message": "Please try again."};
    }
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
  List<SubjectItem> listOfSubject = [];
  List<SubjectItem> tempListOfSubject = [];

  void setListOfSubject({required List<SubjectItem> listOfSubject}) {
    this.listOfSubject = listOfSubject;
    tempListOfSubject = listOfSubject;
    notifyListeners();
  }

  void setTempListOfSubject(
      {required List<SubjectItem> tempListOfStudentSubject}) {
    tempListOfSubject = tempListOfStudentSubject;
    notifyListeners();
  }

  Future<void> getListOfSubjects(
      {required String classId,
      required String? wpId,
      required RoleType roleType}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: roleType == RoleType.teacher
              ? "${Api.teacherSubjectList}?class_id=$classId"
              : "${Api.subjectEndpoint}?student_id=$wpId${'&class_id=$classId'}",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': "${userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          SubjectListModel subjectList = SubjectListModel.fromJson(response);
          setListOfSubject(listOfSubject: subjectList.subjectlist ?? []);
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
      setTempListOfSubject(tempListOfStudentSubject: listOfSubject);
      return;
    }

    List<SubjectItem> searchData = [];
    for (var subject in listOfSubject) {
      if (subject.subName?.toLowerCase().contains(value?.toLowerCase() ?? "") ??
          false) {
        searchData.add(subject);
      }
    }

    setTempListOfSubject(tempListOfStudentSubject: searchData);
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
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: "${Api.subjectDetailEndpoint}/$subjectId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': "${userdata?.cookies}"
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
      {required String? classId, required String? studentId}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      dynamic response = await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: "${Api.timeTableEndpoint}/$classId?sid=${studentId ?? ""}",
          header: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': "${userdata?.cookies}"
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

  //Evaluation parent and student side;
  List<EvaluationItem> evaluationItem = [];

  void setEvaluationItem({required List<EvaluationItem> evaluationItem}) {
    this.evaluationItem = evaluationItem;
    notifyListeners();
  }

  //get evaluation
  void getEvaluation(
      {required String classId, required String studentWpUserId}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
              requestType: RequestType.get,
              header: {
                'Content-Type':
                    'application/x-www-form-urlencoded; charset=UTF-8',
                'Authorization': "Basic $token",
                'Cookie': "${userdata?.cookies}"
              },
              endPoint:
                  "${Api.evaluationEndPoint}?student_id=$studentWpUserId&class_id=$classId")
          .then((res) {
        AppConstants.showCustomToast(
            status: res['status'],
            message: res['Message'] ?? res['message'] ?? "");
        if (res['status']) {
          Evaluation evaluation = Evaluation.fromJson(res);
          setEvaluationItem(evaluationItem: evaluation.data);
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
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
      {required String? studentId,
      required String classId,
      required RoleType roleType}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: roleType == RoleType.teacher
              ? "${Api.teacherSideListOfProfessor}?class_id=$classId"
              : "${Api.teacherEndpoint}?student_id=$studentId&class_id=$classId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': "${userdata?.cookies}"
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

  //Teacher details
  SingleTeacherDetailItem? teacherDetail;

  void setTeacherDetail(
      {required SingleTeacherDetailItem? singleTeacherModel}) {
    teacherDetail = singleTeacherModel;
    notifyListeners();
  }

  //get single teacher details
  void getSingleTeacherDetails({required String teacherWPUserId}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: "${Api.teacherDetailsEndPoint}/$teacherWPUserId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': "${userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          SingleTeacherModel singleTeacherModel =
              SingleTeacherModel.fromJson(response);
          setTeacherDetail(singleTeacherModel: singleTeacherModel.data?[0]);
        }

        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
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

  Future<void> getListOfStudents(
      {required String classId, required RoleType roleType}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: roleType == RoleType.teacher
              ? "${Api.teacherStudentList}?class_id=$classId"
              : "${Api.studentEndpoint}?class_id=$classId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': "${userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          StudentListModel student = StudentListModel.fromJson(response);
          List<StudentItem> studentItemList = student.studentlist ?? [];
          studentItemList
              .sort((a, b) => a.sLname?.compareTo(b.sLname ?? "") ?? 0);
          setListOfStudents(listOfStudents: student.studentlist ?? []);
          setSelectedStudentForFollowUp(studentItem: studentItemList[0]);
        }

        setIsLoading(isLoading: false);
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

  //student details model
  StudentDetails? studentDetails;

  setStudentDetails({required StudentDetails? studentDetails}) {
    this.studentDetails = studentDetails;
    notifyListeners();
  }

  //get student details
  Future<void> getStudentDetails({required String studentId}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: "${Api.studentDetailsEndpoint}/$studentId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': "${userdata?.cookies}"
          }).then((response) {
        if (response['status']) {
          StudentDetailModel studentDetailModel =
              StudentDetailModel.fromJson(response);
          setStudentDetails(studentDetails: studentDetailModel.studentDetails);
        }

        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //is address visible
  bool isAddressAndParentDetailsVisible(
      {required String idOfStudentYouAreSeeingDetails}) {
    if (currentLoggedInUserRole == RoleType.teacher) {
      return true;
    } else if (currentLoggedInUserRole == RoleType.student) {
      return idOfStudentYouAreSeeingDetails == userdata?.wpUsrId;
    } else {
      for (StudentData studentData in userdata?.studentData ?? []) {
        if (studentData.wpUsrId == idOfStudentYouAreSeeingDetails) {
          return true;
        }
      }
      return false;
    }
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
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: Api.transportEndpoint,
          header: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': userdata?.cookies ?? ""
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

  //Teacher Section :
  TeacherClassItem? currentSelectedClass;

  void setCurrentSelectedClass({required TeacherClassItem? teacherClass}) {
    currentSelectedClass = teacherClass;
    notifyListeners();
  }

  List<TeacherClassItem> listOfClassAssignToTeacher = [];

  void setListOfClassAssignToTeacher(
      {required List<TeacherClassItem> listOfClassAssignToTeacher}) async {
    this.listOfClassAssignToTeacher = listOfClassAssignToTeacher;
    notifyListeners();
  }

  void getListOfClassesAssignToTeacher(
      {required bool showLoader, int? fromWhere, String? classId}) async {
    //8 means exam list screen
    //9 edit exam screen

    try {
      setIsLoading(isLoading: showLoader);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: Api.teacherClassList,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': userdata?.cookies ?? ""
          }).then((res) {
        if (res['status']) {
          TeacherClassListModel teacherClass =
              TeacherClassListModel.fromJson(res);
          setListOfClassAssignToTeacher(
              listOfClassAssignToTeacher: teacherClass.data ?? []);
          setCurrentSelectedClass(teacherClass: teacherClass.data?[0]);

          if (fromWhere == 8) {
            getListOfExams(
                classId: teacherClass.data?[0].cid ?? "",
                wpUserId: "",
                roleType: RoleType.teacher);
          }
        }
        setIsLoading(isLoading: false);
      });

      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //get list of parents
  List<ParentItem> listOfParents = [];
  List<ParentItem> tempListOfParents = [];

  void setListOfParents({required List<ParentItem> listOfParents}) {
    this.listOfParents = listOfParents;
    tempListOfParents = listOfParents;

    notifyListeners();
  }

  void setTempListOfParents({required List<ParentItem> tempListOfParents}) {
    this.tempListOfParents = tempListOfParents;
    notifyListeners();
  }

  //get list of parents
  void getListOfParents({required String classId}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: "${Api.teacherSideListOfParents}?class_id=$classId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': userdata?.cookies ?? ""
          }).then((res) {
        if (res['status']) {
          ParentListModel parentListModel = ParentListModel.fromJson(res);
          List<ParentItem> parentList = parentListModel.data ?? [];
          parentList.sort((a, b) => a.pLname?.compareTo(b.pLname ?? "") ?? 0);

          setListOfParents(listOfParents: parentListModel.data ?? []);
        }
        setIsLoading(isLoading: false);
      });

      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //search in parent list
  void searchInParentList(String? value) {
    if (value?.isEmpty ?? true) {
      setTempListOfParents(tempListOfParents: listOfParents);
      return;
    }

    List<ParentItem> searchData = [];
    for (var parentItem in listOfParents) {
      if (parentItem.pFname!
              .toLowerCase()
              .contains(value?.toLowerCase() ?? "") ||
          parentItem.pFname!
              .toLowerCase()
              .contains(value?.toLowerCase() ?? "") ||
          parentItem.userEmail!
              .toLowerCase()
              .contains(value?.toLowerCase() ?? "")) {
        searchData.add(parentItem);
      }
    }

    setTempListOfParents(tempListOfParents: searchData);
  }

  //Teacher Add - Edit event :
  EventTypeModel selectedEventType = AppConstants.eventTypeList[0];

  void setSelectedEventType({required EventTypeModel? eventTypeModel}) {
    selectedEventType = eventTypeModel ?? AppConstants.eventTypeList[0];
    notifyListeners();
  }

  EventColorModel selectedEventColor = AppConstants.eventColorModel[0];

  void setSelectedEventColor({required EventColorModel? eventColorModel}) {
    selectedEventColor = eventColorModel ?? AppConstants.eventColorModel[0];
    notifyListeners();
  }

  //event start date
  DateTime? eventStartDate;

  void setSelectedEventStartDate({required DateTime? date}) {
    eventStartDate = date;
    notifyListeners();
  }

  //event end date
  DateTime? eventEndDate;

  void setSelectedEventEndDate({required DateTime? date}) {
    eventEndDate = date;
    notifyListeners();
  }

  //event start time
  TimeOfDay? startTime;

  //event end time
  TimeOfDay? endTime;

  void setSelectedStartTime({required TimeOfDay? startTime}) {
    this.startTime = startTime;
    endTime = startTime;
    notifyListeners();
  }

  void setSelectedEndTime({required TimeOfDay? endTime}) {
    this.endTime = endTime;
    notifyListeners();
  }

  //date picker
  Future<DateTime?> pickDate({DateTime? startDate}) async {
    //type means start date or end date
    //when user select start date then startDate value will come
    DateTime? dateTime = await showDatePicker(
        locale: Locale('es', 'ES'),
        context: Get.context!,
        firstDate: DateTime.now(),
        lastDate: DateTime(3000));
    return dateTime;
  }

  //time picker
  Future<TimeOfDay?> pickTime() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: Get.context!,
      initialTime: startTime ?? TimeOfDay.now(),
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    return timeOfDay;
  }

  //add event user side
  Future<void> addEditEvent(
      {required String title,
      required String description,
      required String eventStartDate,
      required String eventEndDate,
      required String eventStartTime,
      required String eventEndTime,
      required String eventType,
      required String eventColor,
      String? eventId}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.post,
          endPoint: eventId == null ? Api.eventListEndPoint : "event/$eventId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': userdata?.cookies ?? ""
          },
          body: {
            "etitle": title,
            "edesc": description,
            "sdate": eventStartDate,
            "edate": eventEndDate,
            "stime": eventStartTime,
            "etime": eventEndTime,
            "etype": eventType,
            "ecolor": eventColor,
          }).then((response) async {
        if (response['status']) {
          AppConstants.showCustomToast(
              status: true, message: "Insertado exitosamente");
          clearAddEditEventScreen();
          setIsLoading(isLoading: false);
          getEvents();
          Get.back();
        }
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //Events : student,parent and teacher
  DateTime eventScreenFocusDay = DateTime.now();

  void setEventScreenFocusDay({required DateTime dateTime}) {
    eventScreenFocusDay = dateTime;
    notifyListeners();
  }

  DateTime eventScreenSelectedDay = DateTime.now();

  void setEventScreenSelectedDay({required DateTime dateTime}) {
    eventScreenSelectedDay = dateTime;
    notifyListeners();
  }

  //date time wise events list
  Map<DateTime, List<EventListItemDetail>> mapOfEventsDateWise = {};

  setMapOfEvents(
      {required Map<DateTime, List<EventListItemDetail>> listOfEvent}) {
    mapOfEventsDateWise = listOfEvent;
    notifyListeners();
  }

  List<EventListItemDetail> todayEvent = [];

  void setTodayEvent({required List<EventListItemDetail> eventList}) {
    todayEvent = eventList;
    notifyListeners();
  }

  List<EventListItemDetail> getEventsForDay(DateTime date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    List<EventListItemDetail> events =
        mapOfEventsDateWise.containsKey(DateTime.parse(dateFormat.format(date)))
            ? mapOfEventsDateWise[DateTime.parse(dateFormat.format(date))]!
            : [];
    return events;
  }

  //get list of events for parent,teacher,student
  Future<void> getEvents() async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: currentLoggedInUserRole == RoleType.teacher
              ? Api.teacherEventList
              : Api.eventListEndPoint,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': userdata?.cookies ?? ""
          }).then((response) {
        if (response['status']) {
          Events events = Events.fromJson(response);
          setEventsAccordingDate(eventData: events.eventsList);
        }

        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //filter out events according date
  void setEventsAccordingDate({required List<EventListItem> eventData}) {
    Map<DateTime, List<EventListItemDetail>> eventMap = {};
    DateFormat df = DateFormat("yyyy-MM-dd");
    for (var element in eventData) {
      if (eventMap[element.startDate] != null) {
        eventMap[
                DateTime.parse(df.format(element.startDate ?? DateTime.now()))]!
            .addAll(element.list ?? []);
      } else {
        eventMap[DateTime.parse(
                df.format(element.startDate ?? DateTime.now()))] =
            element.list ?? [];
      }
    }

    setTodayEvent(
        eventList:
            eventMap.containsKey(DateTime.parse(df.format(DateTime.now())))
                ? eventMap[DateTime.parse(df.format(DateTime.now()))]!
                : []);
    mapOfEventsDateWise = eventMap;
  }

  //teacher followed up
  List<FollowedUpItem> listOfStudentFollowedUp = [];
  List<FollowedUpItem> tempListOfStudentFollowedUp = [];

  void setListOfStudentFollowedUp(
      {required List<FollowedUpItem> listOfStudentFollowedUp}) {
    this.listOfStudentFollowedUp = listOfStudentFollowedUp;
    tempListOfStudentFollowedUp = listOfStudentFollowedUp;
    notifyListeners();
  }

  void setTempListOfStudentFollowedUp(
      {required List<FollowedUpItem> tempListOfStudentFollowedUp}) {
    this.tempListOfStudentFollowedUp = tempListOfStudentFollowedUp;
    notifyListeners();
  }

  StudentItem? selectedStudentForFollowedUp;

  void setSelectedStudentForFollowUp({required StudentItem? studentItem}) {
    selectedStudentForFollowedUp = studentItem;
    notifyListeners();
  }

  //get list of followed up
  void getListOfFollowedUp(
      {required String studentId, required String classId}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint:
              "${Api.teacherFollowedUp}?class_id=$classId&student_id=$studentId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': userdata?.cookies ?? ""
          }).then((response) {
        if (response['status']) {
          FollowedUpModel followedUpModel = FollowedUpModel.fromJson(response);
          List<FollowedUpItem> followUpList = followedUpModel.data ?? [];
          followUpList.sort(
              (a, b) => a.list?[0].date?.compareTo(b.list?[0].date ?? "") ?? 1);
          followUpList = followUpList.reversed.toList();
          setListOfStudentFollowedUp(listOfStudentFollowedUp: followUpList);
        }

        setIsLoading(isLoading: false);
      });
      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //search in followed up list
  void searchInFollowedUpList(String? value) {
    if (value?.isEmpty ?? true) {
      setTempListOfStudentFollowedUp(
          tempListOfStudentFollowedUp: listOfStudentFollowedUp);
      return;
    }

    List<FollowedUpItem> searchData = [];
    for (FollowedUpItem item in listOfStudentFollowedUp) {
      FollowedUpItemDetail? followedUpItemDetail = item.list?[0];

      if (followedUpItemDetail?.subjectName
              ?.toLowerCase()
              .contains(value?.toLowerCase() ?? "") ??
          false ||
              followedUpItemDetail!.examName!
                  .toLowerCase()
                  .contains(value?.toLowerCase() ?? "") ||
              followedUpItemDetail.date!
                  .toLowerCase()
                  .contains(value?.toLowerCase() ?? "")) {
        searchData.add(item);
      }
    }

    setTempListOfStudentFollowedUp(tempListOfStudentFollowedUp: searchData);
  }

  //clear event data after add-editing event
  void clearAddEditEventScreen() {
    eventStartDate = DateTime.now();
    eventEndDate = DateTime.now();
    startTime = TimeOfDay.now();
    endTime = TimeOfDay.now();
    selectedEventType = AppConstants.eventTypeList[0];
    selectedEventColor = AppConstants.eventColorModel[0];
    notifyListeners();
  }

  //Exam :
  List<ExamListItem> listOfExams = [];
  List<ExamListItem> tempListOfExams = [];

  void setListOfExams({required List<ExamListItem> listOfExams}) {
    this.listOfExams = listOfExams;
    tempListOfExams = listOfExams;
    notifyListeners();
  }

  void setTempListOfExams({required List<ExamListItem> listOfExams}) {
    tempListOfExams = listOfExams;
    notifyListeners();
  }

  Future<void> getListOfExams(
      {required String classId,
      required String? wpUserId,
      required RoleType roleType}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: roleType != RoleType.teacher
              ? "${Api.studentParentExamListPoint}?student_id=$wpUserId&class_id=$classId"
              : "${Api.teacherExamListPoint}?class_id=$classId",
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': userdata?.cookies ?? ""
          }).then((response) {
        if (response['status']) {
          ExamListModel examListModel = ExamListModel.fromJson(response);
          setListOfExams(listOfExams: examListModel.data ?? []);
        }
      });

      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //search in exam list
  void searchInExamList(String? value) {
    if (value?.isEmpty ?? true) {
      setTempListOfExams(listOfExams: listOfExams);
    }
    // date, exam name, or even subject
    List<ExamListItem> searchData = [];
    for (ExamListItem e in listOfExams) {
      if (e.eName?.toLowerCase().contains(value?.toLowerCase() ?? "") ??
          false ||
              e.subName!.toLowerCase().contains(value?.toLowerCase() ?? "") ||
              e.eSDate!.toLowerCase().contains(value?.toLowerCase() ?? "") ||
              e.eEDate!.toLowerCase().contains(value?.toLowerCase() ?? "")) {
        searchData.add(e);
      }
    }

    setTempListOfExams(listOfExams: searchData);
  }

  //get detail of exam
  ExamDetailItem? examDetailItem;

  void setExamDetailItem({required ExamDetailItem? examDetailItem}) {
    this.examDetailItem = examDetailItem;
    notifyListeners();
  }

  void getDetailsOfExam({required String examId}) async {
    try {
      setIsLoading(isLoading: true);

      await Api.httpRequest(
              requestType: RequestType.get,
              endPoint: "${Api.examDetailEndPoint}/$examId")
          .then((response) {
        if (response['status']) {
          AppConstants.showCustomToast(
              status: response['status'],
              message: response['message'] ?? response['Message'] ?? "");
          ExamDetailsModel examDetailsModel =
              ExamDetailsModel.fromJson(response);

          setExamDetailItem(examDetailItem: examDetailsModel.data);
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  //Add-Edit exam :
  DateTime examStartDate = DateTime.now();

  void setExamStartDate({required DateTime? dateTime}) {
    examStartDate = dateTime ?? DateTime.now();
    notifyListeners();
  }

  DateTime examEndDate = DateTime.now();

  void setExamEndDate({required DateTime? dateTime}) {
    examEndDate = dateTime ?? DateTime.now();
    notifyListeners();
  }

  TimeOfDay examTime = TimeOfDay.now();

  void setExamTime({required TimeOfDay? examTime}) {
    this.examTime = examTime ?? TimeOfDay.now();
    notifyListeners();
  }

  // bool isAllSubjectSelected = false;
  //
  // void setIsAllSubjectSelected({required bool isAllSubjectSelected}) {
  //   this.isAllSubjectSelected = isAllSubjectSelected;
  //   // setListOfSelectedSubjectsId(listOfSelectedSubjectsId: tempListOfSubject.map((e){return e;}).toList());
  //   selectedSubjects.clear();
  //   for(SubjectItem i in tempListOfSubject){
  //     selectedSubjects[i.id ?? ""] = i.subName ?? "";
  //   }
  //   notifyListeners();
  // }
  //
  //
  // //selected subject id for add-edit exam
  // Map<String,String> selectedSubjects = {};
  // void setSelectedSubjects({required Map<String,String> selectedSubjects}){
  //   this.selectedSubjects = selectedSubjects;
  //   notifyListeners();
  // }
  //
  // void addSelectedSubject({required SubjectItem subjectItem}){
  //   selectedSubjects[subjectItem.id ?? ""] = subjectItem.subName ?? "";
  //   notifyListeners();
  // }
  //
  // void removeSelectedSubjects({required SubjectItem subjectItem}){
  //   selectedSubjects.remove(subjectItem.id ?? "");
  //   notifyListeners();
  // }


  //selected subjects for exam
  String? selectedSubjectIdOfExam;
  void setSelectedSubjectOfExam({required String? selectedSubjectIdOfExam}){
    this.selectedSubjectIdOfExam = selectedSubjectIdOfExam;
    notifyListeners();
  }

  //add-edit exam function
  Future<void> addEditExam(
      {String? examId,
      required String classId,
      required String examName,
      required String startDateOfExam,
      required String endDateOfExam,
      required String examTime,
      required String comments,
      required List<String> subjects}) async {
    try {
      setIsLoading(isLoading: true);

      Map<String, String> bodyData = {
        "classid": classId,
        "e_name": examName,
        "exam_start_date": startDateOfExam,
        "exam_end_date": endDateOfExam,
        "time": examTime,
        "comments": comments
      };

      for (int i = 0; i < subjects.length; i++) {
        bodyData["subject_id[$i]"] = subjects[i];
      }
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
          requestType: RequestType.post,
          endPoint: examId == null
              ? Api.teacherAddExamEndPoint
              : "${Api.teacherEditExam}/$examId",
          body: bodyData,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': userdata?.cookies ?? ""
          }).then((response) {
        setIsLoading(isLoading: false);
        AppConstants.showCustomToast(
            status: response['status'],
            message: response['Message'] ?? response['message'] ?? "");
        if (response['status']) {
          setListOfExams(listOfExams: []);
          resetExamData();
          Get.offUntil(MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false);
        }
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //reset exam data
  void resetExamData() {
    setListOfSubject(listOfSubject: []);
    examStartDate = DateTime.now();
    examEndDate = DateTime.now();
    examTime = TimeOfDay.now();
    selectedSubjectIdOfExam = null;
    // selectedSubjects = {};
    // isAllSubjectSelected = false;
    notifyListeners();
  }

  //marks section :
  List<ExamListItem> listOfExamBasedOnSubjects = [];

  void setListOfExamBasedOnSubjects({required List<ExamListItem> listOfExams}) {
    listOfExamBasedOnSubjects = listOfExams;
    notifyListeners();
  }

  ExamListItem? viewMarkSelectedExam;

  void setViewMarkExamSelected({required ExamListItem? examListItem}) {
    viewMarkSelectedExam = examListItem;
    notifyListeners();
  }

  SubjectItem? viewMarkSubjectSelected;

  void setViewMarkSubjectSelected({required SubjectItem? subjectItem}) {
    viewMarkSubjectSelected = subjectItem;
    viewMarkSelectedExam = null;

    if (listOfExams.isNotEmpty) {
      // setListOfExamBasedOnSubjects(listOfExams: );
      List<ExamListItem> examList = listOfExams.where((e) {
        return e.subjectId?.split(",").contains(subjectItem?.id) ?? false;
      }).toList();
      setListOfExamBasedOnSubjects(listOfExams: examList);
    }

    notifyListeners();
  }

  //list of marks of students
  List<MarksItem> listOfMarksItem = [];

  void setListOfMarks({required List<MarksItem> listOfMarksItem}) {
    this.listOfMarksItem = listOfMarksItem;
    notifyListeners();
  }

  List<TextEditingController> listOfMarksController = [];

  void setListOfMarksController(
      {required List<TextEditingController> listOfMarksController}) {
    this.listOfMarksController = listOfMarksController;
    notifyListeners();
  }

  List<TextEditingController> listOfObserverController = [];

  void setListOfObserverController(
      {required List<TextEditingController> listOfObserverController}) {
    this.listOfObserverController = listOfObserverController;
    notifyListeners();
  }

  //list of marks of students
  Future<void> getListOfMarks(
      {required String classId,
      required String subjectId,
      required String examId}) async {
    try {
      setIsLoading(isLoading: true);
      await Api.httpRequest(
              requestType: RequestType.get,
              endPoint:
                  "${Api.teacherMarksListEndPoint}?class_id=$classId&subject_id=$subjectId&exam_id=$examId")
          .then((response) {
        if (response['status']) {
          MarksList marksList = MarksList.fromJson(response);
          setListOfMarksController(
              listOfMarksController: List.generate(marksList.data?.length ?? 0,
                  (index) => TextEditingController()));
          setListOfObserverController(
              listOfObserverController: List.generate(
                  marksList.data?.length ?? 0,
                  (index) => TextEditingController()));
          List<MarksItem> listOfMarks = marksList.data ?? [];
          listOfMarks.sort((a, b) => a.studentLastName?.compareTo(b.studentLastName ?? "") ?? 0);
          setListOfMarks(listOfMarksItem: listOfMarks);
        } else {
          AppConstants.showCustomToast(
              status: false,
              message: response['Message'] ?? response['message'] ?? "");
        }
      });
      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //current view or add-edit marks : for 0 it means only want to see marks so it will be in table form
  // for 1 means want to add-edit marks so it will be in list form which contains marks enter text fields
  int? viewOrAddEditMarks;

  void setViewOrAddEditMarks({required int? viewOrAddEditMarks}) {
    this.viewOrAddEditMarks = viewOrAddEditMarks;
    notifyListeners();
  }

  //add-edit marks
  Future<void> addEditMarks(
      {required String classId,
      required String subjectId,
      required String examId}) async {
    try {
      setIsLoading(isLoading: true);

      Map<String, String> bodyData = {
        "ClassID": classId,
        "SubjectID": subjectId,
        "ExamID": examId,
      };

      if (listOfMarksItem.isNotEmpty) {
        for (int i = 0; i < listOfMarksItem.length; i++) {
          bodyData["sid[$i]"] = listOfMarksItem[i].studentId ?? "";
          bodyData["mark[$i]"] = listOfMarksController[i].text;
          bodyData["remark[$i]"] = listOfObserverController[i].text;
        }
      }

      await Api.httpRequest(
              requestType: RequestType.post, endPoint: "marks", body: bodyData)
          .then((response) async {
        if (response['status']) {
          AppConstants.showCustomToast(
              status: response['status'],
              message: response['status']
                  ? "Agregar/Editar con éxito"
                  : "Por favor, inténtalo de nuevo");
          await getListOfMarks(
                  classId: classId, subjectId: subjectId, examId: examId)
              .then((response) {
            setIsLoading(isLoading: false);
          });
        } else {
          AppConstants.showCustomToast(
              status: false,
              message: response['Message'] ?? response['message'] ?? "");
          setIsLoading(isLoading: false);
        }
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }

  //clear screen after operation
  void clearMarkScreen() {
    setListOfMarks(listOfMarksItem: []);
    setListOfMarksController(listOfMarksController: []);
    setListOfObserverController(listOfObserverController: []);
  }

  //Dinning Screen :
  DinningMenuData? dinningMenuResponse;

  void setDinningMenuResponse({required DinningMenuData? dinningMenuResponse}) {
    this.dinningMenuResponse = dinningMenuResponse;
    notifyListeners();
  }

  //get dinning menu
  void getDinningMenu() async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
              requestType: RequestType.get,
              header: {
                'Content-Type':
                    'application/x-www-form-urlencoded; charset=UTF-8',
                'Authorization': "Basic $token",
                'Cookie': userdata?.cookies ?? ""
              },
              endPoint: Api.dinningSectionEndPoint)
          .then((response) {
        if (response['status']) {
          DinningMenuResponse dinningMenuResponse =
              DinningMenuResponse.fromJson(response);
          setDinningMenuResponse(dinningMenuResponse: dinningMenuResponse.data);
        } else {
          AppConstants.showCustomToast(
              status: false,
              message: response['message'] ?? response['Message'] ?? "");
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  //selected day
  String? currentSelectedDinningDay;

  void setCurrentSelectedDinningDay({required String? selectedDinningDay}) {
    currentSelectedDinningDay = selectedDinningDay;
    notifyListeners();
  }

  //selected dinning month
  MonthModel? selectedDinningMonth;

  void setCurrentSelectedDinningMonth({required MonthModel? dinningMonth}) {
    selectedDinningMonth = dinningMonth;
    if(dinningMonth != null){
      setCurrentSelectedDinningDay(selectedDinningDay: null);
      getDaysOfMonthFromDinningTable(selectedMonth: dinningMonth.id);
    }
    notifyListeners();
  }

  List<DinningStudentItem> dinningStudentList = [];

  void setDinningStudentList(
      {required List<DinningStudentItem> dinningStudentList}) {
    this.dinningStudentList = dinningStudentList;
    notifyListeners();
  }

  List<String?> listOfStatusOfStudentDinning = [];

  void setListOfStatusOfStudentDinning(
      {required List<String?> listOfStatusOfStudentDinning}) {
    this.listOfStatusOfStudentDinning = listOfStatusOfStudentDinning;
    notifyListeners();
  }

  //student id : status
  Map<String, int> mapOfStatusOfStudentDinning = {};

  void setMapOfStatusOfStudentDinning(
      {required Map<String, int> mapOfStatusOfStudentDinning}) {
    this.mapOfStatusOfStudentDinning = mapOfStatusOfStudentDinning;
    notifyListeners();
  }

  void addDinningStatusData(
      {required String keyName, required, required int status}) {
    mapOfStatusOfStudentDinning[keyName] = status;
    notifyListeners();
  }


  //get list of days for dinning month
  List<String> daysList = [];
  void setDaysList({required List<String> daysList}){
    this.daysList = daysList;
    notifyListeners();
  }


  //get Dinning Days of months
  Future<void> getDaysOfMonthFromDinningTable({required int selectedMonth}) async{
      try{

        setIsBottomLoader(isBottomLoader: true);
        await Api.httpRequest(
            requestType: RequestType.get,
            endPoint: "${Api.dinningDaysList}?month=$selectedMonth").then((res){
              if(res['status']){
                DinningMonthListResponse dinningMonthListResponse = DinningMonthListResponse.fromJson(res);
                List<String> days = dinningMonthListResponse.data?.days ?? [];
                setDaysList(daysList: days);

                int currentDay = DateTime.now().day;
                for(int i = currentDay; i <= 31 ; i++){
                  if(days.contains("$i")){
                    setCurrentSelectedDinningDay(selectedDinningDay: "$i");
                    break;
                  }
                }
              }
              setIsBottomLoader(isBottomLoader: false);
        });


      }catch(exception){
        setIsBottomLoader(isBottomLoader: false);
        notifyListeners();
      }
  }


 //dinning settings
  DinningSettings? dinningSettings;

  void setDinningSettings({required DinningSettings? dinningSettings}) {
    this.dinningSettings = dinningSettings;
    notifyListeners();
  }

//get dinning student list
  Future<void> getDinningStudentList(
      {required String classId, required int month, required String day}) async {
    try {
      setIsLoading(isLoading: true);
      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
              requestType: RequestType.get,
              header: {
                'Content-Type':
                    'application/x-www-form-urlencoded; charset=UTF-8',
                'Authorization': "Basic $token",
                'Cookie': userdata?.cookies ?? ""
              },
              endPoint:
                  "${Api.dinningStudentListEndPoint}?class_id=$classId&month=$month&day=$day&current_role=${currentLoggedInUserRole == RoleType.parent ? "parent" : "teacher"}")
          .then((response) {
        if (response['status']) {
          DinningStudentListResponse dinningStudentListResponse =
              DinningStudentListResponse.fromJson(response);
          List<DinningStudentItem> dinningStudentList =
              dinningStudentListResponse.data ?? [];
          setDinningStudentList(dinningStudentList: dinningStudentList);
          Map<String, int> studentDinningStatus = {};
          for (var e in dinningStudentList) {
            studentDinningStatus[e.wpUsrId ?? ""] = e.atten == "1" ? 1 : 0;
          }
          setDinningSettings(
              dinningSettings: dinningStudentListResponse.diningSettings);
          setMapOfStatusOfStudentDinning(
              mapOfStatusOfStudentDinning: studentDinningStatus);
        } else {
          AppConstants.showCustomToast(
              status: false,
              message: response['Message'] ?? response['message'] ?? "");
        }
      });
      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$exception");
    }
  }

//add edit dinning at teacher side
  Future<void> addEditDinningStatus(
      {required int monthNumber, required String day}) async {
    try {
      setIsLoading(isLoading: true);
      Map<String, dynamic> bodyData = {"Month": "$monthNumber", "Day": day};

      List<int> listOfStatus = mapOfStatusOfStudentDinning.values.toList();
      for (int i = 0; i < listOfStatus.length; i++) {
        bodyData["atten[$i]"] = "${listOfStatus[i]}";
      }

      List<String> listOfStudentId = mapOfStatusOfStudentDinning.keys.toList();
      for (int i = 0; i < listOfStatus.length; i++) {
        bodyData["student_id[$i]"] = listOfStudentId[i];
      }

      //all class id  of student
      for (int i = 0; i < dinningStudentList.length; i++) {
        bodyData["class_id[$i]"] = dinningStudentList[i].wpUsrId ?? "";
      }

      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      await Api.httpRequest(
              requestType: RequestType.post,
              endPoint: Api.addEditDinningTeacherSide,
              header: {
                'Content-Type':
                    'application/x-www-form-urlencoded; charset=UTF-8',
                'Authorization': "Basic $token",
                'Cookie': userdata?.cookies ?? ""
              },
              body: bodyData)
          .then((response) async {
        AppConstants.showCustomToast(
            status: response['status'],
            message: response['Message'] ?? response['message'] ?? "");
        setMapOfStatusOfStudentDinning(mapOfStatusOfStudentDinning: {});
        if (response['status']) {
          setDinningStudentList(dinningStudentList: []);
          await getDinningStudentList(
              classId: currentLoggedInUserRole == RoleType.parent
                  ? ""
                  : currentSelectedClass?.cid ?? "",
              month: monthNumber,
              day: day);
          setIsLoading(isLoading: false);
        }
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$exception");
    }
  }

 //teacher's time table screen(Mi Horario)
  List<TeacherScheduleItem> teacherScheduleList = [];

  void setTeacherScheduleList(
      {required List<TeacherScheduleItem> teacherScheduleList}) {
    this.teacherScheduleList = teacherScheduleList;
    notifyListeners();
  }


  //Selected Time Table Item
  TeacherScheduleItem? selectedTeacherScheduleItem;
  void setSelectedTeacherScheduleItem({required TeacherScheduleItem? teacherScheduleItem}){
    selectedTeacherScheduleItem = teacherScheduleItem;
    notifyListeners();
  }


  void getTeacherScheduleList({required String teacherWpUserId}) async {
    try {
      setIsLoading(isLoading: true);
      int day = getCurrentDay() - 1;
      setCurrentSelectedDay(currentSelectedDay: day);
      await Api.httpRequest(
              requestType: RequestType.get,
              endPoint:
                  "${Api.teacherMyScheduleEndPoint}?teacher_id=$teacherWpUserId")
          .then((res) {
        if (res['status']) {
          TeacherScheduleModel teacherScheduleModel = TeacherScheduleModel.fromJson(res);
          setTeacherScheduleList(teacherScheduleList: teacherScheduleModel.sessionList ?? []);
          setSelectedTeacherScheduleItem(teacherScheduleItem: teacherScheduleList[day]);
        }
      });

      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$exception");
    }
  }

//Logged out function : clear all controller data
  void loggedOutClearData() {
    currentLoggedInUserRole = null;
    userdata = null;
    dashboard = null;
    setCurrentBottomIndexSelected(index: 0);
    timeTableList = [];
    particularDayTimeTableData = [];
    tempParticularDayTimeTableData = [];
    studentInfo = null;
    tempTransportList = [];
    transportList = [];
    listOfSubject = [];
    tempListOfSubject = [];
    subjectDetail = null;
    subject = null;
    tempListOfParents = [];
    tempListOfParents = [];
    tempListOfSubject = [];
    tempListOfTeachers = [];
    dashboardExamList = [];
    todayEvent = [];
    // selectedSubjects = {};
    listOfStudentFollowedUp = [];
    tempListOfStudentFollowedUp = [];
    notifyListeners();
  }
}
