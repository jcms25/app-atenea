// To parse this JSON data, do
//
//     final subSlotModel = subSlotModelFromJson(jsonString);

import 'dart:convert';

SubSlotModel subSlotModelFromJson(String str) => SubSlotModel.fromJson(json.decode(str));

String subSlotModelToJson(SubSlotModel data) => json.encode(data.toJson());

class SubSlotModel {
  bool status;
  String message;
  List<SubSlotData> data;

  SubSlotModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubSlotModel.fromJson(Map<String, dynamic> json) => SubSlotModel(
    status: json["status"],
    message: json["message"],
    data: List<SubSlotData>.from(json["data"].map((x) => SubSlotData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SubSlotData {
  String id;
  String classId;
  String timeId;
  String subjectId;
  String sessionId;
  String day;
  dynamic heading;
  String isActive;
  String hour;
  String begintime;
  String endtime;
  String type;
  String subName;

  SubSlotData({
    required this.id,
    required this.classId,
    required this.timeId,
    required this.subjectId,
    required this.sessionId,
    required this.day,
    this.heading,
    required this.isActive,
    required this.hour,
    required this.begintime,
    required this.endtime,
    required this.type,
    required this.subName,
  });

  factory SubSlotData.fromJson(Map<String, dynamic> json) => SubSlotData(
    id: json["id"],
    classId: json["class_id"],
    timeId: json["time_id"],
    subjectId: json["subject_id"],
    sessionId: json["session_id"],
    day: json["day"],
    heading: json["heading"],
    isActive: json["is_active"],
    hour: json["hour"],
    begintime: json["begintime"],
    endtime: json["endtime"],
    type: json["type"],
    subName: json["sub_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "class_id": classId,
    "time_id": timeId,
    "subject_id": subjectId,
    "session_id": sessionId,
    "day": day,
    "heading": heading,
    "is_active": isActive,
    "hour": hour,
    "begintime": begintime,
    "endtime": endtime,
    "type": type,
    "sub_name": subName,
  };
}
