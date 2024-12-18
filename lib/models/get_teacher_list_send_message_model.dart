// To parse this JSON data, do
//
//     final teacherListForSend = teacherListForSendFromJson(jsonString);

import 'dart:convert';

TeacherListForSend teacherListForSendFromJson(String str) => TeacherListForSend.fromJson(json.decode(str));

String teacherListForSendToJson(TeacherListForSend data) => json.encode(data.toJson());

class TeacherListForSend {
  bool status;
  String message;
  List<TeacherItemForSendMessage> data;

  TeacherListForSend({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TeacherListForSend.fromJson(Map<String, dynamic> json) => TeacherListForSend(
    status: json["status"],
    message: json["message"],
    data: List<TeacherItemForSendMessage>.from(json["data"].map((x) =>TeacherItemForSendMessage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TeacherItemForSendMessage {
  String wpUsrId;
  String teacherName;

  TeacherItemForSendMessage({
    required this.wpUsrId,
    required this.teacherName,
  });

  factory TeacherItemForSendMessage.fromJson(Map<String, dynamic> json) => TeacherItemForSendMessage(
    wpUsrId: json["wp_usr_id"],
    teacherName: json["teacher_name"],
  );

  Map<String, dynamic> toJson() => {
    "wp_usr_id": wpUsrId,
    "teacher_name": teacherName,
  };
}
