import 'package:colegia_atenea/models/get_teacher_list_send_message_model.dart';
import 'package:colegia_atenea/models/student_list_model.dart';
import 'package:colegia_atenea/models/teacher/parent_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../services/api.dart';

class MessageSendController extends ChangeNotifier {
  bool isLoading = false;

  void setIsLoading({required bool isLoading}) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  //parent,student send message to teacher:
  List<TeacherItemForSendMessage> teacherList = [];

  void setListOfTeacher(
      {required List<TeacherItemForSendMessage> teacherList}) {
    this.teacherList = teacherList;
    notifyListeners();
  }

  //current selected teacher
  TeacherItemForSendMessage? currentSelectedTeacher;

  void setCurrentTeacherSelected(
      {required TeacherItemForSendMessage? currentSelectedTeacher}) {
    this.currentSelectedTeacher = currentSelectedTeacher;
    notifyListeners();
  }

  //get list of teachers
  void getListOfTeacherItem(
      {required String basicAuthToken,
      required String cookies,
      String? teacherId}) async {
    try {
      setIsLoading(isLoading: true);

      await Api.httpRequest(
          requestType: RequestType.get,
          endPoint: Api.teacherListForMessageSend,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $basicAuthToken",
            'Cookie': cookies
          }).then((response) {
        if (response['status']) {
          TeacherListForSend teacherListForSend =
              TeacherListForSend.fromJson(response);
          setListOfTeacher(teacherList: teacherListForSend.data);
          setIsLoading(isLoading: false);
        }
      });
    } catch (exception) {
      setIsLoading(isLoading: false);
    }
  }


}
