import 'dart:convert';

import 'package:colegia_atenea/models/failed_class_model.dart';
import 'package:colegia_atenea/services/share_preferences.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_new_communication_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:http/http.dart';

import '../models/assistant/assistant_sub_slot_model.dart';
import '../views/screens/login_screen.dart';


enum RequestType{post,get}


class ApiClass{

  String liveBaseUrl = "https://colegioatenea.es/wp-json/scl-api/v1/";
  // String liveBaseUrl = "http://192.168.1.22/colegiaLive/wp-json/scl-api/v1";

  String sendMessage = "message";
  String login = "login";
  String dashboard = "dashboard/";
  // String dashboard = "dashboard";
  String allMessage = "parentSendMessage";
  String timetable = "timetable";
  String teacher = "teachers?";
  String student = "students";
  String subject = "subjects";
  String exam = "exams";
  String marks = "stu-marks";
  String evaluation = "evaluation";
  String attendance = "get_attendance";
  String transportation = "transports";
  String circular = "circular";
  String studentDetail = "student";
  String singleTeacher = "teacher";
  String singleSubject = "subject";
  String singleExam = "exam";
  String classList = "classlist";
  String eventsList = "events";

  Future<dynamic> loginCheck(String username, String password, String role,
      String deviceFCMToken, String deviceType) async {
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
          'device_uuid': deviceFCMToken,
          'device_type': deviceType
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        return {'status': false, "Message": response.body};
      }
    } catch (exception) {
      return {"status": false, "Message": "Error. $exception"};
    }
  }

  Future<dynamic> getDashboard(
      {required String token, required String cookieExample}) async {
    // try {
    //
    // } catch (exception) {
    //   return {'status': false, "Message": "$exception"};
    // }
    Response res = await get(Uri.parse('$liveBaseUrl$dashboard'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': "Basic $token",
          'Cookie': cookieExample
        });
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else if (res.statusCode == 401) {
      sessionExpired();
      return {'status': false, 'Message': 'Session Expired.'};
    } else {
      return {'status': false, "Message": "something went wrong"};
    }

  }

  Future<dynamic> getEvent(String token, String cookie) async {
    try {
      final Response response = await get(
        Uri.parse('$liveBaseUrl$eventsList'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic $token',
          'Cookie': cookie
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Exception occurred"};
      }
    } catch (exception) {
      return {"status": false, "Message": "$exception"};
    }
  }

  Future<dynamic> getMessageAll(String token, String cookie) async {
    try {
      Response res = await get(Uri.parse("$liveBaseUrl$allMessage"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Exception occurred"};
      }
    } catch (exception) {
      return {"status": false, "Message": "Exception occurred : $exception"};
    }
  }

  Future<dynamic> getTimeTable(
      String token, String classId, String cookie) async {
    try {
      Response res = await get(Uri.parse("$liveBaseUrl$timetable/$classId"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getTimeTableOfClass({required String classId,required String studentId,required String token,required String cookie}) async {
    try {
      Response res = await get(Uri.parse("$liveBaseUrl$timetable/$classId?cid=$classId&sid=$studentId"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getTeacher(
      String token, String studentId, String classId, String cookie) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$teacher?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getStudent(
      String token, String classid, String cookie) async {
    try {
      Response res = await get(
          Uri.parse("$liveBaseUrl$student?class_id=$classid"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getSubject(
      String token, String studentId, String classId, String cookie) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$subject?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getExamList(
      String token, String studentId, String classId, String cookie) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$exam?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        // if (data['status']) {
        //   return data;
        // } else {
        //   return Failed.fromJson(data);
        // }
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getMarks(
      String token, String studentId, String classId, String cookie) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$marks?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return data;
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getEvaluation(
      String token, String wpid, String cid, String cookie) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$evaluation?student_id=$wpid&class_id=$cid"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        // sessionExpired();
       return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }

  }

  Future<dynamic> getEvaluationDownload({required String wpId,required String cId}) async{
  try{
    await get(Uri.parse("$liveBaseUrl$evaluation?student_id=1427&class_id=24"));
  }catch(e){
    AppConstants.showCustomToast(status: false, message: "$e");
  }
}

  Future<dynamic> getAttendance(
      String token, String studentId, String classId, String cookie) async {
    try {
      Response res = await get(
          Uri.parse(
              "$liveBaseUrl$attendance?student_id=$studentId${'&class_id=$classId'}"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getTransfer({required String token,required String cookie}) async {
    try {
      Response res = await get(Uri.parse('$liveBaseUrl$transportation'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getCircular(String token, String cookie) async {
    try {
      Response res = await get(Uri.parse("$liveBaseUrl$circular"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getTeacherListForSendMessage(
      String token, String cookie) async {
    try {
      Response res = await get(Uri.parse('${liveBaseUrl}teacherList'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  Future<dynamic> sendMessageToTeacher(
      String token,
      String attachment,
      String senderId,
      String recieverId,
      String subject,
      String message,
      String cookie) async {
    try {
      final MultipartRequest request = MultipartRequest(
          'POST', Uri.parse('${liveBaseUrl}parentSendMessage'));
      request.headers
          .addAll({"Authorization": "Basic $token", 'Cookie': cookie});

      if (attachment.isEmpty) {
        request.fields['attachment'] = attachment;
      }
      else {
        request.files
            .add(await MultipartFile.fromPath('attachment', attachment));
      }
      request.fields['sender_id'] = senderId;
      request.fields['reciever_id[0]'] = recieverId;
      request.fields['subject'] = subject;
      request.fields['msg'] = message;

      StreamedResponse streamResponse = await request.send();
      var response = await Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {'status': false, "Message": "Something Went Wrong"};
    }
  }

  Future<dynamic> getSingleCircular(
      String token, String circularid, String cookie) async {
    try {
      Response res = await get(
          Uri.parse("$liveBaseUrl$circular?id=$circularid"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getStudentDetail(
      String token, String studentid, String cookie) async {
    try {
      Response res = await get(
          Uri.parse("$liveBaseUrl$studentDetail/$studentid"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getSingleSubject(
      String token, String subjectId, String cookie) async {
    try {
      Response res = await get(Uri.parse('$liveBaseUrl$singleSubject/5938'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getSingleTeacher(
      String token, String id, String cookie) async {
    try {
      Response res = await get(Uri.parse('$liveBaseUrl$singleTeacher/$id'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getSingleExam(String token, String id, String cookie) async {
    try {
      Response res = await get(Uri.parse('$liveBaseUrl$singleExam/$id'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return Failed.fromJson(data);
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "Some thing went wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "Exceptions occurred"};
    }
  }

  Future<dynamic> getSingleMessageDetail(
      String token, String messageId, String cookie) async {
    try {
      Response res = await get(
          Uri.parse('$liveBaseUrl$allMessage?mid=$messageId'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return data;
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (exception) {
      return {"status": false, "Message": "$exception"};
    }
  }


  Future<dynamic> getListOfChildCommunication({required String wpUserId}) async{
    try {
      Response res = await get(
          Uri.parse('${liveBaseUrl}studentmessages?sid=$wpUserId'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            // 'Authorization': "Basic $token",
            // 'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data['status']) {
          return data;
        } else {
          return data;
        }
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (exception) {
      return {"status": false, "Message": "$exception"};
    }
  }


  //assistant related apis

  //assistant dashboard data get api
  Future<dynamic> getAsDashboard(String token, String cookie) async {
    try {
      Response res = await get(Uri.parse('${liveBaseUrl}dashboard/?current_role=assistant'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {'status': false, "Message": "Exception Occurred"};
    }
  }

  Future<dynamic> getAsClassList(String token, String cookie) async {
    try {
      Response res = await get(Uri.parse('${liveBaseUrl}classlist'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {'status': false, "Message": "Something Went Wrong"};
    }
  }

  Future<dynamic> getAsSlot(String token, String cookie) async {
    try {
      Response res = await get(Uri.parse('${liveBaseUrl}slotList/'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  Future<dynamic> getAsSlotChildList(
      String token, String id, String cookie) async {
    try {
      Response res = await get(
          Uri.parse('${liveBaseUrl}class-studentList?class_id=$id'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  Future<dynamic> getStudentListForCommonMessage(
      String token, String classId, String cookie) async {
    try {
      Response res = await get(
          Uri.parse("${liveBaseUrl}studentList?class_id=$classId"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  //get sub slot list
  Future<dynamic> getSubSlotList(
      String token, String classId, int day, String cookie) async {
    try {
      Response res = await get(
          Uri.parse('${liveBaseUrl}subslotList/?class_id=$classId&day=$day'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  //send student report message.
  Future<dynamic> sendStudentReport(
      {required String token,
      required String cookie,
      required String senderId,
      required String studentId,
      required List<bool> slotValue,
      required List<TextEditingController>? controller,
      required List<SubSlotData> subSlotData,
      required String subject,
      required String message,
      required String day,
      required String attachment,
      required SelectOptionFromCategory1? desayuno,
      required SelectOptionFromCategory1? merienda,
      required SelectOptionFromCategory1? comida,
      required List<SelectOptionFromCategory3> aseo,
      required SelectOptionFromCategory2? sueno}) async {
    try {
      final MultipartRequest request =
          MultipartRequest('POST', Uri.parse('${liveBaseUrl}communication'));

      request.headers
          .addAll({"Authorization": "Basic $token", 'Cookie': cookie});
      request.fields["sender_id"] = senderId;
      request.fields["slot_id"] = "1";
      request.fields["student_id"] = studentId;
      request.fields["subject"] = subject;
      request.fields["msg"] = message;
      request.fields["day"] = day;

      request.fields['breakfast'] = getSelectedFieldName(desayuno);
      request.fields['snack'] = getSelectedFieldName(merienda);
      request.fields['food'] = getSelectedFieldName(comida);
      request.fields['sleep'] = sueno == null
          ? ""
          : sueno == SelectOptionFromCategory2.si
              ? "Si"
              : "No";

      request.fields['cleanliness'] = aseo
          .map((element) {
            return element == SelectOptionFromCategory3.pipi ? "Pipi" : "Caca";
          })
          .toList()
          .join(",");

      if (attachment.isEmpty) {
        request.fields["attachment"] = "";
      } else {
        request.files
            .add(await MultipartFile.fromPath('attachment', attachment));
      }
      for (int i = 0; i < subSlotData.length; i++) {
        if (slotValue[i]) {
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
      } else if (response.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  //sent Common Message.
  //all parent or to selected parent without attachment.
  Future<dynamic> sendCommonMessageWithOutAttachment(
      Map<String, dynamic> body, String token, String cookie) async {
    try {
      final Response response =
          await post(Uri.parse("${liveBaseUrl}sendCommonMessage"),
              headers: <String, String>{
                'Content-Type':
                    'application/x-www-form-urlencoded; charset=UTF-8',
                'Authorization': "Basic $token",
                'Cookie': cookie
              },
              body: body);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        return res;
      } else if (response.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "please try again"};
      }
    } catch (exception) {
      return {"status": false, "Message": "please try again"};
    }
  }

  //all parent or to selected parent with attachment.
  Future<dynamic> sendCommonMessageWithAttachment(
      {required String token,
      required String cookie,
      required String senderId,
      required String subject,
      required String message,
      required String attachment,
      int? toAllOrParent,
      List<String>? receiverId,
      String? classId}) async {
    try {
      final MultipartRequest request = MultipartRequest(
          'POST', Uri.parse("${liveBaseUrl}sendCommonMessage"));
      request.headers
          .addAll({"Authorization": "Basic $token", 'Cookie': cookie});

      request.files.add(await MultipartFile.fromPath('attachment', attachment));
      request.fields['sender_id'] = senderId;
      //to parent of all student
      if (toAllOrParent == 0) {
        request.fields['classid'] = classId!;
      }
      //to parent of selected student.
      else {
        for (int i = 0; i < receiverId!.length; i++) {
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
      } else if (response.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (exception) {
      return {'status': false, "Message": "Something Went Wrong"};
    }
  }

  //get student report message list.
  Future<dynamic> getStudentReportMessageList(
      String token, String cookie) async {
    try {
      final Response response = await get(
        Uri.parse("${liveBaseUrl}report_communicationList"),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': "Basic $token",
          'Cookie': cookie
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {'status': false, "Message": "Something Went Wrong"};
    }
  }

  //get common message list.
  Future<dynamic> getCommonMessageList(String token, String cookie) async {
    try {
      Response res = await get(
          Uri.parse("${liveBaseUrl}common_communicationList"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  //get Message Details.
  Future<dynamic> getMessageDetails(
      {required int isCommonOrStudentReport,
      required String token,
      required String cookie,
      required String messageId}) async {
    try {
      final Response response = await get(
        Uri.parse("${liveBaseUrl}single_communication/$messageId"),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Authorization': "Basic $token",
          'Cookie': cookie
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "please try again"};
      }
    } catch (exception) {
      Fluttertoast.showToast(msg: "$exception");
      return {"status": false, "Message": "please try again"};
    }
  }

  //get message details using date and studentId.
  Future<dynamic> getMessageDetailsUsingDate(
      {required String token,
      required String cookie,
      required String date,
      required String studentId}) async {
    try {
      final Response response = await post(
          Uri.parse("${liveBaseUrl}single_reportByDate"),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          },
          body: <String, dynamic>{
            'date': date,
            'student_id': studentId
          });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {"status": false, "Message": "please try again"};
      }
    } catch (_) {
      return {"status": false, "Message": "please try again"};
    }
  }

  //send Message to Assistant
  Future<dynamic> sendMessageToAssistant(
      {required String token,
      required String cookie,
      required String senderId,
      required String receiverId,
      required String studentId,
      required String subject,
      required String message,
      required String attachment}) async {
    try {
      final MultipartRequest request =
          MultipartRequest('POST', Uri.parse("${liveBaseUrl}sendPtoAMessage"));
      request.headers
          .addAll({"Authorization": "Basic $token", 'Cookie': cookie});

      if (attachment.isEmpty) {
        request.fields["attachment"] = attachment;
      } else {
        request.files
            .add(await MultipartFile.fromPath('attachment', attachment));
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
      } else if (response.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (exception) {
      return {"status": false, "Message": "please try again. $exception"};
    }
  }

  Future<dynamic> getAssistantList(String token, String cookie) async {
    try {
      Response res = await get(Uri.parse('${liveBaseUrl}assistanList'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Authorization': "Basic $token",
            'Cookie': cookie
          });
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data;
      } else if (res.statusCode == 401) {
        sessionExpired();
        return {'status': false, 'Message': 'Session Expired.'};
      } else {
        return {'status': false, "Message": "Something Went Wrong"};
      }
    } catch (_) {
      return {'status': false, "Message": "Something Went Wrong"};
    }
  }

  String getSelectedFieldName(SelectOptionFromCategory1? selectedCategory) {
    if (selectedCategory == null) {
      return "";
    }
    return selectedCategory == SelectOptionFromCategory1.todo
        ? "Todo"
        : selectedCategory == SelectOptionFromCategory1.bastante
            ? "Bastante"
            : selectedCategory == SelectOptionFromCategory1.poco
                ? "Poco"
                : "Nada";
  }

}

void sessionExpired() async {
  await SharedPref.initialization();
  await SharedPref.pref.setBool(SharedPref.isLogin, false);
  Fluttertoast.showToast(msg: 'sessionExpired'.tr);
  Get.offAll(const LoginScreen());
}
