// To parse this JSON data, do
//
//     final timetablelist = timetablelistFromJson(jsonString);

import 'dart:convert';

Timetablelist? timetablelistFromJson(String str) => Timetablelist.fromJson(json.decode(str));

String timetablelistToJson(Timetablelist? data) => json.encode(data!.toJson());

class Timetablelist {
  Timetablelist({
    this.status,
    this.message,
    this.time,
    this.sessionList,
  });

  bool? status;
  String? message;
  List<String>? time;
  List<SessionList>? sessionList;

  factory Timetablelist.fromJson(Map<String, dynamic> json) => Timetablelist(
    status: json["status"],
    message: json["Message"],
    time: json["Time"] == null ? [] : List<String>.from(json["Time"]!.map((x) => x)),
    sessionList: json["SessionList"] == null ? [] : List<SessionList>.from(json["SessionList"]!.map((x) => SessionList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "Time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
    "SessionList": sessionList == null ? [] : List<dynamic>.from(sessionList!.map((x) => x.toJson())),
  };
}

class SessionList {
  SessionList({
    this.day,
    this.data,
  });

  String? day;
  List<Datum?>? data;

  factory SessionList.fromJson(Map<String, dynamic> json) => SessionList(
    day: json["day"],
    data: json["data"] == null ? [] : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.classId,
    this.timeId,
    this.subjectId,
    this.sessionId,
    this.day,
    this.heading,
    this.isActive,
    this.hour,
    this.begintime,
    this.endtime,
    this.type,
    this.subName,
  });

  String? id;
  String? classId;
  String? timeId;
  String? subjectId;
  String? sessionId;
  String? day;
  dynamic heading;
  String? isActive;
  String? hour;
  String? begintime;
  String? endtime;
  String? type;
  List<String?>? subName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    subName: json["sub_name"] == null ? [] : List<String?>.from(json["sub_name"]!.map((x) => x)),
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
    "sub_name": subName == null ? [] : List<dynamic>.from(subName!.map((x) => x)),
  };
}


