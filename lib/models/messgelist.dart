// To parse this JSON data, do
//
//     final messagelist = messagelistFromJson(jsonString);

import 'dart:convert';

Messagelist messagelistFromJson(String str) => Messagelist.fromJson(json.decode(str));

String messagelistToJson(Messagelist data) => json.encode(data.toJson());

class Messagelist {
  Messagelist({
    required this.status,
    required  this.message,
    required  this.data,
  });

  bool status;
  String message;
  Data data;

  factory Messagelist.fromJson(Map<String, dynamic> json) => Messagelist(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required  this.inboxlist,
    required this.sendlist,
    required this.deletelist,
  });

  List<DeletelistElement> inboxlist;
  List<DeletelistElement> sendlist;
  List<DeletelistElement> deletelist;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    inboxlist: List<DeletelistElement>.from(json["inboxlist"].map((x) => DeletelistElement.fromJson(x))),
    sendlist: List<DeletelistElement>.from(json["sendlist"].map((x) => DeletelistElement.fromJson(x))),
    deletelist: List<DeletelistElement>.from(json["deletelist"].map((x) => DeletelistElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "inboxlist": List<dynamic>.from(inboxlist.map((x) => x.toJson())),
    "sendlist": List<dynamic>.from(sendlist.map((x) => x.toJson())),
    "deletelist": List<dynamic>.from(deletelist.map((x) => x.toJson())),
  };
}

class DeletelistElement {
  DeletelistElement({
    required this.mid,
    required  this.sId,
    required  this.rId,
    required this.subject,
    required  this.msg,
    required this.replayId,
    required  this.mainMId,
    required   this.delStat,
    required  this.sRead,
    required this.rRead,
    required  this.mDate,
    required this.attachments,
    this.studentId, this.id,
    this.senderName
  });

  String? mid;
  String? sId;
  String? studentId;
  String? id;
  String? rId;
  String? subject;
  String? msg;
  String? replayId;
  String? mainMId;
  String? delStat;
  String? sRead;
  String? rRead;
  DateTime mDate;
  String? attachments;
  String? senderName;

  factory DeletelistElement.fromJson(Map<String, dynamic> json) => DeletelistElement(
    mid: json["mid"],
    id : json["id"],
    sId: json["s_id"],
    rId: json["r_id"],
    subject: json["subject"],
    msg: json["msg"],
    replayId: json["replay_id"],
    mainMId: json["main_m_id"],
    delStat: json["del_stat"],
    sRead: json["s_read"],
    rRead: json["r_read"],
    mDate: DateTime.parse(json["m_date"]),
    attachments: json["attachments"],
    studentId : json["student_id"],
    senderName : json["sender_name"]
  );

  Map<String, dynamic> toJson() => {
    "mid": mid,
    "s_id": sId,
    "r_id": rId,
    "student_id" : studentId,
    "id" : id,
    "subject": subject,
    "msg": msg,
    "replay_id": replayId,
    "main_m_id": mainMId,
    "del_stat": delStat,
    "s_read": sRead,
    "r_read": rRead,
    "m_date": mDate.toIso8601String(),
    "attachments": attachments,
    "sender_name" : senderName
  };
}
