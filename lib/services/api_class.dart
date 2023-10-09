import 'dart:convert';
import 'package:colegia_atenea/models/Failed.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../models/assistant/assistant_sub_slot_model.dart';
class Apiclass {
  String embedBaseUrl = "http://colegioatenea.embedinfosoft.com/wp-json/scl-api/v1/";
  String liveBaseUrl = "https://colegioatenea.es/wp-json/scl-api/v1/";
  // String BASEURL = "https://colegioatenea.embedinfosoft.com/wp-json/scl-api/v1/";
  String sendsms = "message";
  String login = "login";
  String dashboard = "dashboard";
  String allmessge = "parentSendMessage";
  String timetable = "timetable";
  String teacher = "teachers?";
  String student = "students";
  String subject = "subjects";
  String exam = "exams";
  String marks = "stu-marks";
  String evaluation = "evaluation";
  String attendence = "get_attendance";
  String transportation = "transports";
  String circular = "circular";
  String studentdetail = "student";
  String singleteacher = "teacher";
  String singlesubject = "subject";
  String singleexam = "exam";
  String classlist = "classlist";
  String eventsList = "events";

  Future<dynamic> loginCheck(
      String username, String password, String role,String deviceFCMToken,String deviceType) async {
    try {
      final Response response = await post(
        Uri.parse('$liveBaseUrl$login'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: <String, dynamic>{
          'username': username,
          'password': password,
          'reg_select_role': role,
          'device_uuid':deviceFCMToken,
          'device_type':deviceType
        },
      );
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);

        return data;
      }else{
        return {'status': false, "Message": "Exception Occurred"};
      }
    } catch (exception) {
      return {"status": false, "Message": "Error. $exception"};
    }


  }

  Future<dynamic> getDashboard(String token) async {
    try {
      Response res =
      await get(Uri.parse('$liveBaseUrl$dashboard'), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Authorization': "Basic $token",
      });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      }
      else {
        return {'status': false, "Message": "something went wrong"};
      }
    }catch(_){
      return {'status' : false, "Message" : "something went wrong"};
    }

  }

  Future<dynamic> getEvent(String token) async {
    try {
      final Response response = await get(
        Uri.parse('$liveBaseUrl$eventsList'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic $token',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        return {"status": false, "Message": "Exception occurred"};
      }
    } catch (exception) {
      return {"status": false, "Message": "$exception"};
    }
  }

  Future<dynamic> getMessageAll(String token) async {
    try {
      Response res =
          await get(Uri.parse("$liveBaseUrl$allmessge"), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Authorization': "Basic $token",
      });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else {
        return {"status": false, "Message": "Exception occurred"};
      }
    } catch (exception) {
      return {"status": false, "Message": "Exception occurred : $exception"};
    }
  }

  Future<dynamic> getTimeTable(String token, String classId) async {
    try {
      Response res = await get(Uri.parse("$liveBaseUrl$timetable/$classId"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getTeacher(
      String token, String studentId, String classId) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$teacher?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getStudent(String token, String classid) async {
    try {
      Response res = await get(Uri.parse("$liveBaseUrl$student?class_id=$classid"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }


  }

  Future<dynamic> getSubject(
      String token, String studentId, String classId) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$subject?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getExamList(
      String token, String studentId, String classId) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$exam?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getMarks(
      String token, String studentId, String classId) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$marks?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return data;
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getEvaluation(String token, String wpid, String cid) async {
    try {
      Response res = await get(
          Uri.parse("$liveBaseUrl$evaluation?student_id=$wpid${'&class_id=$cid'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getAttendance(
      String token, String studentId, String classId) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$attendence?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic>? getTransfer(String token) async {
    try {
      Response res = await get(Uri.parse('$liveBaseUrl$transportation'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getCircular(String token) async {
    try {
      Response res =
          await get(Uri.parse("$liveBaseUrl$circular"), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Authorization': "Basic $token",
      });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getTeacherListForSendMessage(String token) async {
    try {
      Response res = await get(
          Uri.parse(
              '${liveBaseUrl}teacherList'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      }
      else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }

  }

  Future<dynamic> sendMessageToTeacher(String token,String attachment,String senderId,String recieverId,String subject,String message) async{

    try{
      final MultipartRequest request = MultipartRequest(
          'POST',Uri.parse('${liveBaseUrl}parentSendMessage')
      );
      request.headers.addAll({
        "Authorization": "Basic $token"
      });

      if(attachment.isEmpty){
        request.fields['attachment'] = attachment;
      }
      else{
        request.files.add(await MultipartFile.fromPath('attachment',attachment));
      }
      request.fields['sender_id'] = senderId;
      request.fields['reciever_id[0]'] = recieverId;
      request.fields['subject'] = subject;
      request.fields['msg'] = message;

      StreamedResponse streamResponse = await request.send();
      var response = await Response.fromStream(streamResponse);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        return data;
      }
      else{
        return {'status': false, "Message": "Something Went Wrong"};
      }

    }catch(_){
      return {'status': false, "Message": "Something Went Wrong"};
    }
  }

  Future<dynamic> getSingleCircular(
    String token,
    String circularid,
  ) async {
    try {
      Response res = await get(Uri.parse("$liveBaseUrl$circular?id=$circularid"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getStudentDetail(String token, String studentid) async {
    try {
      Response res = await get(Uri.parse("$liveBaseUrl$studentdetail/$studentid"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getSingleSubject(String token, String id) async {
    try {
      Response res = await get(Uri.parse('$liveBaseUrl$singlesubject/$id'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getSingleTeacher(String token, String id) async {
    try {
      Response res = await get(Uri.parse('$liveBaseUrl$singleteacher/$id'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getSingleExam(String token, String id) async {
    try {
      Response res = await get(Uri.parse('$liveBaseUrl$singleexam/$id'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getSingleMessageDetail(String token, String messageId) async{
    // try {
    //
    // } catch (exception) {
    //   print(exception);
    //   return {"status": false, "Message": "$exception"};
    // }
    Response res = await get(
        Uri.parse(
            '$liveBaseUrl$allmessge?mid=$messageId'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': "Basic $token",
        });
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      if (data['status']) {

        return data;
      } else {
        return data;
      }
    }
    else {
      return {'status': false, "Message": "Something Went Wrong"};
    }

  }

  //assistant related api's

  //assistant dashboard data get api
  Future<dynamic> getAsDashboard(String token) async {
    try {
      Response res = await get(
          Uri.parse(
              '${liveBaseUrl}dashboard/'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {'status': false, "Message": "Exception Occurred"};
    }
  }

  Future<dynamic> getAsClassList(String token) async {
    try{
      Response res = await get(
          Uri.parse(
              '${liveBaseUrl}classlist'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    }catch(_){
      return {'status': false, "Message": "Something Went Wrong"};
    }
  }

  Future<dynamic> getAsSlot(String token) async {
    try {
      Response res = await get(
          Uri.parse(
              '${liveBaseUrl}slotList/'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  Future<dynamic> getAsSlotChildList(String token, String id) async {
    try {
      Response res = await get(
          Uri.parse(
              '${liveBaseUrl}class-studentList?class_id=$id'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  Future<dynamic> getStudentListForCommonMessage(
      String token, String classId) async {
    try {
      Response res = await get(
          Uri.parse(
              "${liveBaseUrl}studentList?class_id=$classId"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  //get sub slot list
  Future<dynamic> getSubSlotList(String token, String classId,int day) async {
    try {
      Response res = await get(
          Uri.parse(
              '${liveBaseUrl}subslotList/?class_id=$classId&day=$day'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      }
      else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  //send student report message.
  Future<dynamic> sendStudentReport({required String token,required String senderId,required String studentId,required List<bool> slotValue,required List<TextEditingController>? controller,required List<SubSlotData> subSlotData,required String subject,required String message,required String day,required String attachment}) async{
    try{
      final MultipartRequest request = MultipartRequest(
          'POST',Uri.parse('${liveBaseUrl}communication')
      );

      request.headers.addAll({
        "Authorization": "Basic $token"
      });
      request.fields["sender_id"] = senderId;
      request.fields["slot_id"] = "1";
      request.fields["student_id"] = studentId;
      request.fields["subject"] = subject;
      request.fields["msg"] = message;
      request.fields["day"] = day;
      if(attachment.isEmpty){
        request.fields["attachment"] = "";
      }else{
        request.files.add(await MultipartFile.fromPath('attachment',attachment));
      }
      for(int i=0;i<subSlotData.length;i++){
        if(slotValue[i]){
          request.fields["time_id[$i]"] = subSlotData[i].timeId;
          request.fields["subject_id[$i]"] = subSlotData[i].subjectId;
          request.fields["text[$i]"] = controller![i].text;
          request.fields["is_active[$i]"] = "1";
        }
      }

      StreamedResponse streamResponse = await request.send();
      var response = await Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      }
      else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    }catch(_){
      return {"status" : false, "Message": "please try again"};
    }
  }

  //sent Common Message.
  //all parent or to selected parent without attachment.
  Future<dynamic> sendCommonMessageWithOutAttachment(Map<String,dynamic> body,String token) async{
      try{
        final Response response = await post(
            Uri.parse("${liveBaseUrl}sendCommonMessage"),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
              'Authorization': "Basic $token",
            },
            body: body
        );
        if(response.statusCode == 200){
          var res = json.decode(response.body);
          return res;
        }else{
          return {"status": false, "Message": "please try again"};
        }
      }catch(exception){
        return {"status": false, "Message": "please try again"};
      }
  }

  //all parent or to selected parent with attachment.
  Future<dynamic> sendCommonMessageWithAttachment({required String token,required String senderId,required String subject,required String message,required String attachment,int? toAllOrParent,List<String>? receiverId,String? classId}) async{
    try{
      final MultipartRequest request = MultipartRequest('POST',Uri.parse("${liveBaseUrl}sendCommonMessage"));
      request.headers.addAll({
        "Authorization": "Basic $token"
      });

      request.files.add(await MultipartFile.fromPath('attachment',attachment));
      request.fields['sender_id'] = senderId;
      //to parent of all student
      if(toAllOrParent == 0){
        request.fields['classid'] = classId!;
      }
      //to parent of selected student.
      else{
        for(int i=0;i<receiverId!.length;i++){
          request.fields['reciever_id[$i]'] = receiverId[i];
        }
      }
      request.fields['subject'] = subject;
      request.fields['msg'] = message;

      StreamedResponse streamResponse = await request.send();
      var response = await Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        return data;
      }
      else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    }catch(exception){
      return {'status': false, "Message": "Something Went Wrong"};
    }
  }


  //get student report message list.
  Future<dynamic> getStudentReportMessageList(String token) async{
    try{
      final Response response = await get(Uri.parse("${liveBaseUrl}report_communicationList"),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': "Basic $token",
        },
        );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    }catch(_){
      return {'status': false, "Message": "Something Went Wrong"};
    }
  }

  //get common message list.
  Future<dynamic> getCommonMessageList(String token) async {
    try {
      Response res = await get(
          Uri.parse(
              "${liveBaseUrl}common_communicationList"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      }
      else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  //get Message Details.
  Future<dynamic> getMessageDetails({required int isCommonOrStudentReport,required String token,required String messageId}) async{
    try{
      final Response response = await get(Uri.parse("${liveBaseUrl}single_communication/$messageId"),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': "Basic $token",
        },
      );
      if(response.statusCode == 200){
        var data = json.decode(response.body);
        return data;
      }else{
        return {"status": false, "Message": "please try again"};
      }
    }catch(exception){
      Fluttertoast.showToast(msg: "$exception");
      return {"status": false, "Message": "please try again"};
    }
  }

  //get message details using date and studentId.
  Future<dynamic> getMessageDetailsUsingDate({required String token,required String date,required String studentId}) async{
    try{
      final Response response = await post(Uri.parse("${liveBaseUrl}single_reportByDate"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          },
          body: <String,dynamic>{
            'date' :  date,
            'student_id' : studentId
          }
      );
      if(response.statusCode == 200){
        var data = json.decode(response.body);
        return data;
      }
      else{
        return {"status": false, "Message": "please try again"};
      }
    }catch(_){
      return {"status": false, "Message": "please try again"};
    }
  }


  //send Message to Assistant
  Future<dynamic> sendMessageToAssistant({required String token,required String senderId,required String receiverId,required String studentId,required String subject,required String message,required String attachment}) async{

    try {
      final MultipartRequest request = MultipartRequest('POST',Uri.parse("${liveBaseUrl}sendPtoAMessage"));
      request.headers.addAll({
        "Authorization": "Basic $token"
      });

      if(attachment.isEmpty){
        request.fields["attachment"] = attachment;
      }else{
        request.files.add(await MultipartFile.fromPath('attachment',attachment));
      }

      request.fields["subject"] = subject;
      request.fields["msg"] = message;
      request.fields["sender_id"] = senderId;
      request.fields["receiver_id"] = receiverId;
      request.fields["student_id"] = studentId;

      StreamedResponse streamResponse = await request.send();
      var response = await Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      }
      else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (exception) {
      return {"status": false, "Message": "please try again. $exception"};
    }

  }

  Future<dynamic> getAssistantList(String token) async{
    try{
      Response res = await get(
          Uri.parse(
              '${liveBaseUrl}assistanList'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    }catch(_){
      return {'status': false, "Message": "Something Went Wrong"};
    }

  }
}
